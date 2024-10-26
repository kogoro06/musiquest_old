import { setupSongSelection } from "./songSelection";
import { setupRecording } from "./controllers/recording";
import { setupAnalysis } from "./analysis";

document.addEventListener("turbo:load", () => {
  setupSongSelection();
  setupRecording();
  setupAnalysis();
});
