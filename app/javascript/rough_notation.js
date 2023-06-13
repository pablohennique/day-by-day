import { annotate } from 'rough-notation'

const e1 = document.querySelector('#home-annotate');
const annotation = annotate(e1, { type: 'underline' });

const annotate = () => {
  annotation.show();
}

export { annotate }
