{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  bitarray,
  datasets,
  flask,
  python-dotenv,
  ninja,
  scipy,
  tqdm,
  transformers,
  ujson,
  gitpython,
  torch,
  faiss,
}:

buildPythonPackage rec {
  pname = "colbert-ai";
  version = "0.2.21";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "colbert_ai";
    hash = "sha256-qNb9tOInLysI7Tf45QlgchYNhBXR5AWFdRiYt35iW6s=";
  };

  # ImportError: cannot import name 'AdamW' from 'transformers'
  # https://github.com/stanford-futuredata/ColBERT/pull/390
  postPatch = ''
    substituteInPlace colbert/training/training.py \
      --replace-fail \
      "from transformers import AdamW, get_linear_schedule_with_warmup" \
      "from transformers import get_linear_schedule_with_warmup; from torch.optim import AdamW"
  '';

  pythonRemoveDeps = [ "git-python" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    bitarray
    datasets
    faiss
    flask
    gitpython
    python-dotenv
    ninja
    scipy
    torch
    tqdm
    transformers
    ujson
  ];

  pythonImportsCheck = [ "colbert" ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "Fast and accurate retrieval model, enabling scalable BERT-based search over large text collections in tens of milliseconds";
    homepage = "https://github.com/stanford-futuredata/ColBERT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bachp
    ];
  };
}
