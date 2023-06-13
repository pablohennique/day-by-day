// import { annotate } from 'rough-notation'

const e1 = document.querySelector('#home-annotate');

const annotate = () => {
  const annotation = annotate(e1, { type: 'underline' });
  annotation.show();
}

export { annotate }
