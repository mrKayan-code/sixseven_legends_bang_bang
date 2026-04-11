class DecisionTreeNode {

  final String? splitFeature;
  final Map<String, DecisionTreeNode>? children;
  final String? predictedClass;

  DecisionTreeNode({
    this.splitFeature,
    this.children,
    this.predictedClass,
  });

  bool get isLeaf => predictedClass != null;
}
