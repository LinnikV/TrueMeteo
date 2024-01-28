import { Controller } from "@hotwired/stimulus";

function timer(func, timeout = 1000){
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}

export default class extends Controller {
  initialize() {
    this.submit = timer(this.submit.bind(this));
  }
  submit(e) {
    this.element.requestSubmit();
  }
}



