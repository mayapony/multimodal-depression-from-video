#!/bin/bash

set -e

NO_CHUNKED_DIR=./data/DAIC-WOZ/no-chunked/

# 解压
python ./scripts/feature_extraction/daicwoz/untar_data.py --root-dir ./data/DAIC-WOZ/backup/ --dest-dir ./data/DAIC-WOZ/original_data/

# 保存空的 npz 到 no_voice_idxs 和 no_face_idxs 文件夹下
python ./scripts/feature_extraction/daicwoz/get_no_idxs.py --data-dir ./data/DAIC-WOZ/original_data/ --dest-dir ./data/DAIC-WOZ/no-chunked/

# COVAREP 使用 COVAREP 采集到的音频特征 10ms 为一个 frame
# shape of COVAREP: (127521, 74), (time, feature)
python ./scripts/feature_extraction/daicwoz/prepare_covarep.py --src-root ./data/DAIC-WOZ/original_data/ --modality-id audio_covarep --dest-root $NO_CHUNKED_DIR
python ./scripts/feature_extraction/daicwoz/split_into_chunks.py --source-dir $NO_CHUNKED_DIR --modality-id audio_covarep --no-idxs-id no_voice_idxs --dest-dir ./data/DAIC-WOZ/data/ --frame-rate 1000

# FORMANTS 声道共振峰
# 127520 * 5
python ./scripts/feature_extraction/daicwoz/prepare_formant.py --src-root ./data/DAIC-WOZ/original_data/ --modality-id audio_formant --dest-root $NO_CHUNKED_DIR
python ./scripts/feature_extraction/daicwoz/split_into_chunks.py --source-dir $NO_CHUNKED_DIR --modality-id audio_formant --no-idxs-id no_voice_idxs --dest-dir ./data/DAIC-WOZ/data/ --frame-rate 1000

# 68 3D FACIAL LANDMARKS
# 38256 * 68 * 3
python ./scripts/feature_extraction/daicwoz/prepare_clnf_features3D.py --src-root ./data/DAIC-WOZ/original_data/ --modality-id facial_3d_landmarks --dest-root $NO_CHUNKED_DIR
python ./scripts/feature_extraction/daicwoz/split_into_chunks.py --source-dir $NO_CHUNKED_DIR --modality-id facial_3d_landmarks --no-idxs-id no_face_idxs --dest-dir ./data/DAIC-WOZ/data/ --frame-rate 1000

# FACIAL ACTION UNITS
# 38256 * 20
python ./scripts/feature_extraction/daicwoz/prepare_clnf_aus.py --src-root ./data/DAIC-WOZ/original_data/ --modality-id facial_aus --dest-root $NO_CHUNKED_DIR
python ./scripts/feature_extraction/daicwoz/split_into_chunks.py --source-dir $NO_CHUNKED_DIR --modality-id facial_aus --no-idxs-id no_face_idxs --dest-dir ./data/DAIC-WOZ/data/ --frame-rate 1000

# GAZE
# 38256 * 4 * 3
# time, (v0 v1 vh0 vh1), [(x0, y0, z0), (...), (...)]
python ./scripts/feature_extraction/daicwoz/prepare_clnf_gaze.py --src-root ./data/DAIC-WOZ/original_data/ --modality-id gaze --dest-root $NO_CHUNKED_DIR
python ./scripts/feature_extraction/daicwoz/split_into_chunks.py --source-dir $NO_CHUNKED_DIR --modality-id gaze --no-idxs-id no_face_idxs --dest-dir ./data/DAIC-WOZ/data/ --frame-rate 1000

# HEAD POSE
# 38256 * 2 * 3
# time, (Tx Ty Tz), (Rx Ry Rz)
python ./scripts/feature_extraction/daicwoz/prepare_clnf_pose.py --src-root ./data/DAIC-WOZ/original_data/ --modality-id head_pose --dest-root $NO_CHUNKED_DIR
python ./scripts/feature_extraction/daicwoz/split_into_chunks.py --source-dir $NO_CHUNKED_DIR --modality-id head_pose --no-idxs-id no_face_idxs --dest-dir ./data/DAIC-WOZ/data/ --frame-rate 1000
