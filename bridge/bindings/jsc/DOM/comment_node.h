/*
 * Copyright (C) 2020 Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

#ifndef KRAKENBRIDGE_COMMENT_NODE_H
#define KRAKENBRIDGE_COMMENT_NODE_H

#include "bindings/jsc/DOM/node.h"
#include "bindings/jsc/js_context.h"

namespace kraken::binding::jsc {

void bindCommentNode(std::unique_ptr<JSContext> &context);

class JSCommentNode : public JSNode {
public:
  JSCommentNode() = delete;
  explicit JSCommentNode(JSContext *context);

  static JSCommentNode *instance(JSContext *context);

  JSObjectRef instanceConstructor(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount,
                                  const JSValueRef *arguments, JSValueRef *exception) override;

  class CommentNodeInstance : public NodeInstance {
  public:
    CommentNodeInstance() = delete;
    explicit CommentNodeInstance(JSCommentNode *jsCommentNode);
    JSValueRef getProperty(JSStringRef name, JSValueRef *exception) override;
    void setProperty(JSStringRef name, JSValueRef value, JSValueRef *exception) override;
    void getPropertyNames(JSPropertyNameAccumulatorRef accumulator) override;

  private:
    JSStringRef data;

    std::array<JSStringRef, 2> propertyNames{
      JSStringCreateWithUTF8CString("data"),
      JSStringCreateWithUTF8CString("length"),
    };
  };
};

} // namespace kraken::binding::jsc

#endif // KRAKENBRIDGE_COMMENT_NODE_H
