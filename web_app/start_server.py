#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
家务零花钱打卡 - 服务器启动脚本
"""

import os
import subprocess
import sys
import webbrowser
import time

def check_node():
    """检查 Node.js 是否安装"""
    try:
        result = subprocess.run(['node', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ Node.js 已安装: {result.stdout.strip()}")
            return True
    except:
        pass
    print("❌ 未检测到 Node.js，请先安装 Node.js")
    print("下载地址: https://nodejs.org/")
    return False

def check_npm():
    """检查 npm 是否安装"""
    try:
        result = subprocess.run(['npm', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✅ npm 已安装: {result.stdout.strip()}")
            return True
    except:
        pass
    print("❌ 未检测到 npm")
    return False

def install_dependencies():
    """安装依赖"""
    print("\n📦 正在安装依赖...")
    result = subprocess.run([sys.executable if 'python' in sys.executable.lower() else 'python', '-m', 'pip', 'install', 'requests'], 
                          capture_output=True, text=True)
    
    # 使用 npm 安装
    proc = subprocess.Popen(['npm', 'install'], 
                          cwd=os.path.dirname(os.path.abspath(__file__)),
                          stdout=subprocess.PIPE, 
                          stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    
    if proc.returncode == 0:
        print("✅ 依赖安装成功")
        return True
    else:
        print(f"❌ 依赖安装失败: {stderr.decode()}")
        return False

def start_server():
    """启动服务器"""
    print("\n🚀 正在启动服务器...")
    
    # 启动服务器进程
    proc = subprocess.Popen(
        [sys.executable if 'python' in sys.executable.lower() else 'python', '-m', 'http.server', '3000'],
        cwd=os.path.join(os.path.dirname(os.path.abspath(__file__)), 'web_app'),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    
    # 等待服务器启动
    time.sleep(1)
    
    # 打开浏览器
    webbrowser.open('http://localhost:3000')
    
    print("\n✅ 服务器已启动!")
    print("📱 访问地址: http://localhost:3000")
    print("\n按 Ctrl+C 停止服务器")
    
    try:
        proc.wait()
    except KeyboardInterrupt:
        print("\n🛑 服务器已停止")
        proc.terminate()

def main():
    print("=" * 50)
    print("家务零花钱打卡 - 服务器启动器")
    print("=" * 50)
    
    # 检查 Node.js
    if not check_node():
        input("\n按回车键退出...")
        return
    
    # 检查 npm
    if not check_npm():
        input("\n按回车键退出...")
        return
    
    # 安装依赖
    if not install_dependencies():
        input("\n按回车键退出...")
        return
    
    # 启动服务器
    start_server()

if __name__ == '__main__':
    main()
