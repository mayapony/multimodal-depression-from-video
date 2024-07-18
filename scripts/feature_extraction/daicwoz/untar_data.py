import argparse
import os

from tqdm import tqdm

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--root-dir", type=str,
                        default="./data/DAIC-WOZ/backup/")
    parser.add_argument("--dest-dir", type=str,
                        default="./data/DAIC-WOZ/data/")
    parser.add_argument("--type", type=str, default="zip")

    args = parser.parse_args()

    tar_files = sorted(os.listdir(args.root_dir))

    for tar_file in tqdm(tar_files):
        tar_path = os.path.join(args.root_dir, tar_file)
        target_dir = os.path.join(args.dest_dir, tar_file.split('_')[0])
        os.makedirs(target_dir, exist_ok=True)

        if args.type == "tar":
            os.system(f"tar -xf {tar_path} -C {args.dest_dir}")
        elif args.type == "zip":
            os.system(
                f"unzip {tar_path} -d {target_dir}")
