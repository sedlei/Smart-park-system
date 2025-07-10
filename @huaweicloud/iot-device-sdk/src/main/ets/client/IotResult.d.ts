export declare class IotResult {
    static readonly SUCCESS: IotResult;
    static readonly FAIL: IotResult;
    static readonly TIMEOUT: IotResult;
    /**
     * 结果码，0表示成功，其他为失败
     */
    result_code: number;
    /**
     * 结果描述
     */
    result_desc: string;
    /**
     * 处理结果
     *
     * @param resultCode 结果码
     * @param resultDesc 结果描述
     */
    constructor(resultCode: number, resultDesc: string);
}
