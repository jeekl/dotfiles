;; This is the first thing to get loaded.

(setq dotfiles-dir (file-name-directory (or load-file-name (buffer-file-name))))

(add-to-list 'load-path (expand-file-name
                         "lisp" (expand-file-name
                                 "org" (expand-file-name
                                        "vendor" dotfiles-dir))))

;; Load up Org Mode and Babel
(require 'org)
(require 'org-install)

;; load up the main file
(org-babel-load-file (expand-file-name "emacs.org" dotfiles-dir))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("2676b33658130bbc6789b4e658a86536b7a2338b" "3c062d124b4e45e73ac60f575fbb953d94cc47b6" "be1433fdc4cb4970586ccb2476726f8b49ce3a9a" "869bd9901803d0525c676a982b3b507402411bde" "85bddb9979fedf4d25e934d4688908fa8fbb3256" "9cb37271c85ad12892cda5fa188e0e3393087d7d" "d43bf6882b77ce5db06124c497a36cb25c66a996" "56fe278a808736c9ad5c497896cd3fce8574f267" "aa9010ce4eaebb9191bf5a0000766e57510568bb" "66b7bd06838bfcc9f8eaf980c8f63f1af1f09c60" "b2c0914cca1aec8b29fae71ced03aabcb4cbcba0" "c3c7db7dcf56fd65a1dac84c4ccfad17825ea371" "7366eca9fb6d051e8aa224e5bfe8a013d626d568" "ad2d7451477a9ab27c837c8e1f2843226a76b7ee" "3f44cd1f4d46e14574ce4a211675c735319cba3f" "db682227626e798c952eda07853156c13ee5fbbf" "b7a555e3a1cd1e628541dc906919a48325092b69" "44916fb387541d073a7aa63ee17d5f067b461030" "dc59297259e382e14d94fdf3b1949e32908df74e" "628eb9ae7c56ba43556e30c475eea7c8e519ebfd" "3cc2a9c3c403337f0328f427649a192d98c39532" "0cf8aa455c0d73b55566b9fb1cdea468adefa74f" "65d8102db37a740f5ce7e345d440d552a157a29d" "6c1e0813446223240118012dca6cd13448d2895d" "0c69f6b9c84fd7d5a2ac307070f311c3c31a9db6" "a37f4618b7e1ab123f11d40865947d0e5f5ea5c3" "c9958db0f496731c29b1129674a5a0f9009d3b05" "a784f6ac59f73c4eb3cde402cb0594cf55648fd5" "46f1eca93e140258af5bf87d56e972eeabd731c9" "d74c8ca86b2ba554ab5190ee08fb96cdf4c1f119" "84869893304becd072809e2b190ed2ab1c9ea22c" "94347dfefa6ce6e1328965363dffabc9a49b7a9b" "75c7550188bbf624874cf7bf2fcc44d9effac907" "d867b4fbfae96a31ade2a2f352ff247f6273cde2" "325d1642e3ecf42aa64243b6f24802a8258e3382" "bccc3e306d6a14b97b5066f853526833b5274df3" "33d459ef1fb689fb35d13029f09376d0acb0e3d0" "0057c7a05200e82cc6ab524b0e73904a740a9bf7" "5378c25e123ee267fec5ac7406c7c833c08990cf" "20e5371909467b9e6fbd80c2badfc9a66129e2e3" "40a0cf5803ab18471a2a93cf9c56b8591435069e" "24e71e1c93092f3fd4d246cdc8302c2e326cddb4" "d9d3b8ae8e734822377796e34608013438862473" "e35b1299990629ed02a1b89a4f9aa4431c954575" default)))
 '(org-agenda-files (quote ("~/.emacs.d/emacs.new.org" "~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/work.org" "~/Dropbox/org/appointments.org" "~/tmp/testcal.org" "~/Dropbox/org/remember-collection.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
