#import "REAParamNode.h"
#import "REAValueNode.h"
#import "REANodesManager.h"

@implementation REAParamNode {
  NSMutableArray<REANodeID> *_argstack;
  NSNumber *_prevCallID;
}

- (instancetype)initWithID:(REANodeID)nodeID config:(NSDictionary<NSString *,id> *)config
{
  if ((self = [super initWithID:nodeID config:config])) {
    _argstack = [NSMutableArray<REANodeID> arrayWithCapacity:0];
  }
  return self;
}

- (void)setValue:(NSNumber *)value
{
  REANode *node = [self.nodesManager findNodeByID:[_argstack lastObject]];
  NSNumber *callID = self.updateContext.callID;
  self.updateContext.callID = _prevCallID;
  [(REAValueNode*)node setValue:value];
  self.updateContext.callID = callID;
}

- (void)beginContext:(NSNumber*) ref
          prevCallID:(NSNumber*) prevCallID
{
  _prevCallID = prevCallID;
  [_argstack addObject:ref];
}

- (void)endContext
{
  [_argstack removeLastObject];
}


- (id)evaluate
{
  NSNumber *callID = self.updateContext.callID;
  self.updateContext.callID = _prevCallID;
  REANode * node = [self.nodesManager findNodeByID:[_argstack lastObject]];
  id val = [node value];
  self.updateContext.callID = callID;
  return val;
}

@end