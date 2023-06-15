import os
import sys
from md2notion import convert, notion_renderer
from notion.client import NotionClient

def import_folder_to_notion(token_v2, folder_path, target_page_url):
    # 初始化Notion.so客户端
    client = NotionClient(token_v2=token_v2)

    # 遍历文件夹中的文件
    for file_name in os.listdir(folder_path):
        if file_name.endswith(".md"):
            file_path = os.path.join(folder_path, file_name)
            with open(file_path, "r", encoding="utf-8") as file:
                # 读取Markdown内容
                markdown_content = file.read()

                # 将Markdown内容转换为Notion块
                page = client.get_block(target_page_url)
                convert(markdown_content, page, notion_renderer)

if __name__ == "__main__":
    # 解析命令行参数
    token_v2 = sys.argv[1]
    folder_path = sys.argv[2]
    target_page_url = sys.argv[3]

    # 调用函数将文件夹中的Markdown文件导入到Notion
    import_folder_to_notion(token_v2, folder_path, target_page_url)

