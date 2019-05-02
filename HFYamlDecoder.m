//
//  HFYamlDecoder.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFYamlDecoder.h"
#import "yaml.h"
#import <dlfcn.h>

/*
 some lazy loaded external functions to libyaml
 If libyaml is installed, they work.
 If libyaml is not installed, they do nothing
 */

void* hf_libyaml()
{
    static void* libyaml = nil;
    if (libyaml == nil)
    {
        libyaml = dlopen("libyaml.dylib", RTLD_LAZY);
    }
    return libyaml;
}

int hf_yaml_parser_load(yaml_parser_t *parser, yaml_document_t *document){
    static int(*func)(yaml_parser_t *, yaml_document_t *) = nil;
    if (func == nil)
    {
        func = dlsym(hf_libyaml(), "yaml_parser_load");
        if (func == nil) return 0;
    }
    return func(parser, document);
}

void hf_yaml_document_delete(yaml_document_t* document)
{
    static void (*func)(yaml_document_t *) = nil;
    if (func == nil)
    {
        func = dlsym(hf_libyaml(), "yaml_document_delete");
        if (func == nil) return;
    }
    func(document);
}

yaml_node_t* hf_yaml_document_get_root_node(yaml_document_t* document)
{
    static yaml_node_t* (*func)(yaml_document_t *) = nil;
    if (func == nil)
    {
        func = dlsym(hf_libyaml(), "yaml_document_get_root_node");
        if (func == nil) return nil;
    }
    return func(document);
}

yaml_node_t* hf_yaml_document_get_node(yaml_document_t* document, int index)
{
    static yaml_node_t* (*func)(yaml_document_t *, int) = nil;
    if (func == nil)
    {
        func = dlsym(hf_libyaml(), "yaml_document_get_node");
        if (func == nil) return nil;
    }
    return func(document, index);
}

void hf_yaml_parser_set_input_string(yaml_parser_t* parser, const unsigned char *input, size_t size)
{
    static void(*func)(yaml_parser_t*, const unsigned char *, size_t) = nil;
    if (func == nil)
    {
        func = dlsym(hf_libyaml(), "yaml_parser_set_input_string");
        if (func == nil) return;
    }
    return func(parser, input, size);
}

int hf_yaml_parser_initialize(yaml_parser_t* parser)
{
    static int(*func)(yaml_parser_t *) = nil;
    if (func == nil)
    {
        func = dlsym(hf_libyaml(), "yaml_parser_initialize");
        if (func == nil) return 0;
    }
    return func(parser);

}
@interface HFYamlDecoder ()

@property (assign) yaml_parser_t* parser;

@end

@implementation HFYamlDecoder

- (void)reportError:(NSError**)error with:(NSString*)string
{
    if (error == nil) return;
    *error = [NSError errorWithDomain:@"HFUIErrorDomain"
                                 code:-100
                             userInfo:@{NSLocalizedFailureReasonErrorKey: string}];
}

- (id)decodeWithError:(NSError**)error
{
    yaml_document_t* document = calloc(sizeof(yaml_document_t), 1);
    if (!hf_yaml_parser_load(_parser, document))
    {
        free(document);
        [self reportError: error
                     with: [NSString stringWithFormat: NSLocalizedString(@"failed to load yaml document: %s",@"report a parsing error from yaml-parser"),_parser->problem]];
        return nil;
    }
    yaml_node_t* root = hf_yaml_document_get_root_node(document);
    id result = [self decodeNode: root inDocument:document withError: error];
    hf_yaml_document_delete(document);
    free(document);
    return result;
}

- (void)dealloc
{
    if (_parser != nil)
    {
        free(_parser);
        _parser = nil;
    }
}

- (NSString*)decodeStringFromNode: (yaml_node_t*)node inDocument:(yaml_document_t* __unused)document withError:(NSError** __unused)error
{
    NSData* utf8Data = [NSData dataWithBytes:node->data.scalar.value length:node->data.scalar.length];
    return [[NSString alloc] initWithData:utf8Data encoding:NSUTF8StringEncoding];
}

- (NSArray*)decodeArrayFromNode: (yaml_node_t*)node inDocument:(yaml_document_t*)document withError:(NSError**)error
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (yaml_node_item_t* item = node->data.sequence.items.start; item < node->data.sequence.items.top; item++)
    {
        yaml_node_t* subNode = hf_yaml_document_get_node(document, *item);
        id each = [self decodeNode:subNode inDocument:document withError:error];
        if (each != nil)
        {
            [array addObject: each];
        }
        else
        {
            return nil;
        }
    }
    return array;
}

- (NSDictionary*)decodeDictionaryFromNode: (yaml_node_t*)node inDocument:(yaml_document_t*)document withError:(NSError**)error
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    for (yaml_node_pair_t* item = node->data.mapping.pairs.start; item < node->data.mapping.pairs.top; item++)
    {
        yaml_node_t* keyNode = hf_yaml_document_get_node(document, item->key);
        id key = [self decodeNode:keyNode inDocument:document withError:error];
        yaml_node_t* valueNode = hf_yaml_document_get_node(document, item->value);
        id value = [self decodeNode:valueNode inDocument:document withError:error];
        if (key != nil && value != nil)
        {
            [dict setObject:value forKey:key];
        }
        else
        {
            return nil;
        }
    }
    return dict;
}

- (id)decodeNode:(yaml_node_t*)node inDocument:(yaml_document_t*)document withError:(NSError**)error
{
    switch (node->type) {
        case YAML_SCALAR_NODE:
            return [self decodeStringFromNode: node inDocument: document withError: error];
        case YAML_SEQUENCE_NODE:
            return [self decodeArrayFromNode: node inDocument: document withError: error];
        case YAML_MAPPING_NODE:
            return [self decodeDictionaryFromNode: node inDocument: document withError: error];
        case YAML_NO_NODE:
            return nil;
    }
    return nil;
}

+ (id _Nullable)propertyListFromData:(NSData*)data error:(NSError**)error
{
    HFYamlDecoder* decoder = [[self alloc] initWithData: data error:error];
    if (decoder == nil)
        return nil;
    return [decoder decodeWithError: error];
}

- (instancetype)initWithData:(NSData*)data error:(NSError**)error
{
    self = [self init];
    if (self != nil)
    {
        _parser = nil;
        if (hf_libyaml() == nil)
        {
            [self reportError:error with:NSLocalizedString(@"libYAML not installed, please install (e.g via Homebrew)", @"shown if libYAML was detect missing")];
            return nil;
        }
        _parser = calloc(sizeof(yaml_parser_t), 1);
        if (!hf_yaml_parser_initialize(_parser))
        {
            [self reportError:error with:NSLocalizedString(@"failed to initialize libYAML parser", @"shown when libYAML is available but parser couldn't be initialized")];
            free(_parser);
            _parser = nil;
            return nil;
        }
        hf_yaml_parser_set_input_string(_parser, data.bytes, data.length);
    }
    return self;
}

+ (NSDictionary* _Nullable)dictionaryFromData:(NSData*)data error:(NSError**)error
{
    id propertyList = [self propertyListFromData:data error:error];
    if ([propertyList isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary*)propertyList;
    }
    [[self alloc] reportError:error with:NSLocalizedString(@"No Dictionary found in YAML file", @"error shown when the YAML file was valid but didn't contain a Dictionary")];
    return nil;
}
@end
