enum class TreeKind {
  Oak,
  Redwood,
  Willow
};

class Tree {
public:
    Tree(TreeKind kind);
private:
    TreeKind kind;
};
