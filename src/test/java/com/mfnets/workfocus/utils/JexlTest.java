package com.mfnets.workfocus.utils;

import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.reflect.Tree;
import org.apache.commons.jexl3.*;
import org.junit.Test;

/**
 * jexl表达式测试类
 *
 * @author Jonathan
 * @version 2016/5/4 18:41
 * @since JDK 7.0+
 */
public class JexlTest {

    private static final JexlEngine ENGINE = new JexlBuilder().silent(false).cache(128).strict(true).create();
    private static final JxltEngine JXLT = ENGINE.createJxltEngine();

    @Test
    public void test1() {
        // Create or retrieve an engine
        JexlEngine jexl = new JexlBuilder().create();

        // Create an expression
        String jexlExp = "tree.printTree()";
        JexlExpression e = jexl.createExpression(jexlExp);

        // Create a context and add data
        JexlContext jc = new MapContext();
        jc.set("tree", new Tree("1", "22"));

        // Now evaluate the expression, getting the result
        Object o = e.evaluate(jc);

        System.out.println(o.toString());
    }


    @Test
    public void test2() {
        StringUtils.abbr("asdsadsa", 3);
        // Create or retrieve an engine
        JexlEngine jexl = new JexlBuilder().create();
        // Create an expression
        String jexlExp = "math.max(a,b)";
        JexlExpression e = jexl.createExpression(jexlExp);
        JexlContext jc = new MapContext();
        jc.set("math", Math.class);
        jc.set("a", 1);
        jc.set("b", 23);
        Object o = e.evaluate(jc);
        System.out.println(o.toString());
    }

    @Test
    public void test3() {
        JexlEngine jexl = new JexlBuilder().create();

        String jexlExp = "stringUtils.abbr(tree.name,length)";

        JexlExpression e = jexl.createExpression(jexlExp);
        JexlContext jc = new MapContext();
        jc.set("stringUtils", StringUtils.class);
        jc.set("tree", new Tree("1111111111", "qwertyyuioasdfdgdf"));
        jc.set("length", 4);
        Object o = e.evaluate(jc);
        System.out.println(o.toString());
    }


    @Test
    public void test4() {
        JexlEngine jexl = new JexlBuilder().create();
        JexlScript e = jexl.createScript("if (true) { 'hello'; }");
        JexlContext jc = new MapContext();
        Object o = e.execute(jc);
        System.out.println(o.toString());
    }

    @Test
    public void test5() {
        JexlEngine jexl = new JexlBuilder().create();
        JexlScript e = jexl.createScript("{stringUtils.abbr(tree.name,length)}");
        JexlContext jc = new MapContext();
        jc.set("stringUtils", StringUtils.class);
        jc.set("tree", new Tree("1111111111", "qwertyyuioasdfdgdf"));
        jc.set("length", 4);
        Object o = e.execute(jc);
        System.out.println(o.toString());
    }

    @Test
    public void test6() {
        JxltEngine.Expression e = JXLT.createExpression("${stringUtils.abbr(tree.name,length)}");
        JexlContext jc = new MapContext();
        jc.set("stringUtils", StringUtils.class);
        jc.set("tree", new Tree("1111111111", "qwertyyuioasdfdgdf"));
        jc.set("length", 4);
        Object o = e.evaluate(jc);
        System.out.println(o.toString());
    }


}
