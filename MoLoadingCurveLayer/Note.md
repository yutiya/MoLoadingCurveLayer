+ (BOOL)needsDisplayForKey:(NSString *)key
{
if ([key isEqualToString:@"progress"]) {
return YES;
}

return [super needsDisplayForKey:key];
}

该静态方法可以指定使用CA动画时,key属性的变化可以让layer对象自动调用setNeedsDisplay方法

// clockwise NO => 逆时针填充  YES => 顺时针填充
角度是顺时针增加，横截，最右端为0起始，2π结束，得到一个完整的圆
CGPathAddArc(path, NULL, x, y, radius, endAngle, startAngle, NO);

layer对象使用KVO监听自身的属性,在layer执行ca动画时,会不停调用dealloc方法,导致KVO失效

在执行CA动画，自动调用drawInContext方法时,只有CA中指定的属性才会变化，其余属性全失效（默认值）
当CA动画执行完，所有属性取之前的值，重新赋值的属性，如果和之前不一致，又会出现隐式动画