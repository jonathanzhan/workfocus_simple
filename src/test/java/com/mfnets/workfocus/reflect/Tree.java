package com.mfnets.workfocus.reflect;

import java.io.Serializable;

/**
 * java反射机制的测试实体类(树型结构，用于后面的el表达式)
 *
 * @author Jonathan
 * @since JDK 7.0+
 */
public class Tree implements Serializable, TreeInterface {

    private static final long serialVersionUID = 4430834192807522343L;

    private String id;//id

    private String name;//name

    private Tree parent;//父节点

    public Tree() {
    }

    public Tree(String id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public void printTree() throws Exception {
        System.out.println("method printTree");
    }

    @Override
    public void printTree(String id, String name) {
        this.id = id;
        this.name = name;
        System.out.println(toString());

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Tree getParent() {
        return parent;
    }

    public void setParent(Tree parent) {
        this.parent = parent;
    }

    @Override
    public String toString() {
        return "Tree{" +
                "id='" + this.id + '\'' +
                ", name='" + this.name + '\'' +
                '}';
    }
}
