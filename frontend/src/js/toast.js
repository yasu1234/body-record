import { ToastSeverity } from 'primevue/api';
import 'primevue/resources/themes/md-light-indigo/theme.css';

export class toastService {
  constructor(toastInstanse, defaultLifeTime) {
    this.toastInstanse = toastInstanse
    this.defaultLifeTime = defaultLifeTime ? defaultLifeTime : "3000" 
  }
  displayInfo(title, body, lifeTime = this.defaultLifeTime){
    this.toastInstanse.add({severity: ToastSeverity.INFO, summary: title, detail: body, life: lifeTime});
  }

  displayError(title, body){
    this.toastInstanse.add({severity: ToastSeverity.ERROR, summary: title, detail: body, life: "10000"});
  }
}
