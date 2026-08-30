#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""启动云端同步服务器"""

import subprocess
import sys
import os
import webbrowser
import threading
import time

def check_node():
    """检查 Node.js 是否安装"""
    try:
        result = subprocess.run(['node', '--version'], capture_output=True, text=True)
        print(f"Node.js 版本: {result.stdout.strip()}")
        return True
    except:
        print("❌ 未检测到 Node.js，请先安装 Node.js")
        print("下载地址: https://nodejs.org/")
        return False

def check_npm():
    """检查 npm 是否安装"""
    try:
        result = subprocess.run(['npm', '--version'], capture_output=True, text=True)
        print(f"npm 版本: {result.stdout.strip()}")
        return True
    except:
        print("❌ 未检测到 npm")
        return False

def install_dependencies():
    """安装依赖"""
    print("\n正在安装依赖...")
    subprocess.run(['npm', 'install'], cwd=os.path.dirname(os.path.abspath(__file__)))
    print("✅ 依赖安装完成")

def start_server():
    """启动服务器"""
    print("\n正在启动服务器...")
    print("=" * 50)
    subprocess.run(['node', 'server.js'], cwd=os.path.dirname(os.path.abspath(__file__)))

def open_browser():
    """打开浏览器"""
    time.sleep(2)
    webbrowser.open('http://localhost:3000')

def main():
    print("=" * 50)
    print("家务零花钱打卡 - 云端同步版")
    print("=" * 50)
    
    # 检查环境
    if not check_node():
        return
    if not check_npm():
        return
    
    # 安装依赖
    install_dependencies()
    
    # 启动服务器
    server_thread = threading.Thread(target=start_server)
    server_thread.daemon = True
    server_thread.start()
    
    # 打开浏览器
    open_browser()
    
    print("\n服务器已启动！")
    print("访问地址: http://localhost:3000")
    print("按 Ctrl+C 停止服务器")
    
    # 保持主线程运行
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n服务器已停止")

if __name__ == '__main__':
    main()
