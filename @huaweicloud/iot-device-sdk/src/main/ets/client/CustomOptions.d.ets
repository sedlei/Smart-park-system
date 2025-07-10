import { CustomBackoffHandler } from "./handler/CustomBackoffHandler";
/**
 * 自定义连接选项
 */
export declare class CustomOptions {
    /**
     * 是否使用自动重连功能
     */
    private _reConnect;
    set reConnect(value: boolean);
    get reConnect(): boolean;
    /**
     * 退避系数， 默认为1000，单位毫秒
     */
    private _backoff;
    set backoff(value: number);
    get backoff(): number;
    /**
     * 最小重连时间，默认为1000，单位毫秒
     */
    private _minBackoff;
    set minBackoff(value: number);
    get minBackoff(): number;
    /**
     * 最大重连时间，默认为30 * 1000，单位毫秒
     */
    private _maxBackoff;
    set maxBackoff(value: number);
    get maxBackoff(): number;
    private _customBackoffHandler;
    set customBackoffHandler(value: CustomBackoffHandler | null);
    get customBackoffHandler(): CustomBackoffHandler | null;
    /**
     * 正在传输但还未收到确认的消息数量，默认为65535
     */
    private _maxInflight;
    set maxInflight(value: number);
    get maxInflight(): number;
    /**
     * 离线消息缓存队列大小，默认5000
     */
    private _offlineBufferSize;
    set offlineBufferSize(value: number);
    get offlineBufferSize(): number;
}
