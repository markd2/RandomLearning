#include "tree.h"

Tree::Tree(TreeKind kind) {
    this->kind = kind;
}

Fraction<int, float> getMagicNumber() {
    return Fraction<int, float>(10, 20.0);
}
