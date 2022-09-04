// Entry point for the build script in your package.json
import "bootstrap"
import "./controllers"
import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"
import { initFlatpickr } from "./plugins/flatpickr";

initFlatpickr();

import "@rails/actiontext";
import { AttachmentUpload } from "@rails/actiontext/app/javascript/actiontext/attachment_upload"

addEventListener("trix-attachment-add", event => {
  const { attachment, target } = event

  if (attachment.file) {
    const upload = new AttachmentUpload(attachment, target)
    upload.start()
  }
})
