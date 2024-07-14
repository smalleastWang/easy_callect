const sortDefsToTop = {
  name: 'sortDefsToTop',
  type: 'full',
  fn: (ast) => {
    const svgElem = ast.children.find(elem => elem.name === 'svg');
    if (!svgElem) return ast;

    const defsElems = [];
    const otherElems = [];

    svgElem.children.forEach((elem) => {
      if (elem.name === 'defs') {
        defsElems.push(elem);
      } else {
        otherElems.push(elem);
      }
    });

    svgElem.children = [...defsElems, ...otherElems];
    return ast;
  },
};

module.exports = {
  plugins: [
    {
      name: 'preset-default',
      params: {
        overrides: {
          removeViewBox: false,
          addAttributesToSVGElement: {
            attributes: [
              { xmlns: 'http://www.w3.org/2000/svg' },
            ],
          },
          moveElemsAttrsToGroup: false,
          moveGroupAttrsToElems: false,
          collapseGroups: false,
        },
      },
    },
    {
      name: 'removeDimensions',
      active: true,
    },
    {
      name: 'sortAttrs',
      active: true,
    },
    {
      name: 'cleanupEnableBackground',
      active: true,
    },
    {
      name: 'removeUnknownsAndDefaults',
      active: true,
    },
    {
      name: 'removeUselessDefs',
      active: false,
    },
    sortDefsToTop,  // 添加自定义插件
  ],
};