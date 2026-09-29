source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY: cross-PR branch pins so CI can resolve the in-flight
# metanorma-document render stack (moved flavor models + registry) and
# the pubid-2 / relaton-bib 2.2 chain. Revert each pin once the
# corresponding change releases:
#   - metanorma-standoc (fix/boilerplate-paragraphs-quote): standoc 3.5
#   - metanorma-document (fix/nested-block-inline-dispatch): #75
#   - metanorma-iso (feat/model-validation-migration): IsoDocument model
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "fix/boilerplate-paragraphs-quote"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "fix/nested-block-inline-dispatch"
gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "metanorma-generic", github: "metanorma/metanorma-generic", branch: "feat/move-generic-document"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "feat/model-validation-migration"
# CI resolved leptris 1.9.242, whose native XML parser rejects
# multibyte UTF-8 (canon HTML comparison dies on the IHO cover
# address); 1.9.270 parses it. Test-only pin.
gem "leptris", "~> 1.9.270"
gem "relaton-bib", "~> 2.2.0.pre.alpha.1"
gem "pubid", github: "pubid/pubid", branch: "main"

eval_gemfile("Gemfile.devel") rescue nil
