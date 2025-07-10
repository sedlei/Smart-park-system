import { ClientConf, IoTMqttQos } from "./ClinetConf";
import { CommandListener } from "./listener/CommandListener";
import { PropertyListener } from "./listener/PropertyListener";
import { RawDeviceMessageListener } from "./listener/RawDeviceMessageListener";
import { ShadowListener } from "./listener/ShadowListener";
import { CustomOptions } from "./CustomOptions";
import { AbstractDevice } from "../service/AbstractDevice";
import { RawMessageListener } from "./listener/RawMessageListener";
import { MessageReceivedHandler } from "./handler/MessageReceivedHandler";
import { MqttClient } from "@ohos/mqtt";
import { ConnectListener } from "./listener/ConnectionListener";
import { RawMessage } from "../requests/RawMessage";
import { DeviceEvent } from "../requests/DeviceEvent";
import { IoTMqttResponse } from "./IoTMqttResponse";
import { IoTMqttPublishOptions } from "./IoTMqttPublishOptions";
import { ServiceProperty } from "../requests/ServiceProperty";
import { DeviceMessage } from "../requests/DeviceMessage";
import { CommandRsp } from "../requests/CommandRsp";
import { IotResult } from "./IotResult";
import { ShadowRequest } from "../requests/ShadowRequest";
export declare class DeviceClient {
    private static readonly SDK_VERSION;
    private static readonly MESSAGE_DOWN_TOPIC;
    private static readonly COMMAND_DOWN_TOPIC;
    private static readonly PROPERTY_SET_TOPIC;
    private static readonly PROPERTY_GET_TOPIC;
    private static readonly SHADOW_RESPONSE_TOPIC;
    private static readonly SHADOW_GET_RESPONSE_TOPIC;
    private static readonly EVENT_DOWN_TOPIC;
    private static readonly CONNECT_BAD_USERNAME_OR_PASSWORD;
    private _propertyListener;
    /**
     * 设置属性监听器，用于接收平台下发的属性读写。
     * 此监听器只能接收平台到直连设备的请求，子设备的请求由AbstractGateway处理
     *
     * @param propertyListener 属性监听器
     */
    set propertyListener(value: PropertyListener | null);
    get propertyListener(): PropertyListener | null;
    private _commandListener;
    /**
     * 设置命令监听器，用于接收平台下发的命令。
     * 此监听器只能接收平台到直连设备的请求，子设备的请求由AbstractGateway处理
     *
     * @param commandListener 命令监听器
     */
    set commandListener(value: CommandListener | null);
    get commandListener(): CommandListener | null;
    private _shadowListener;
    /**
     * 设置设备影子监听器，用于接收设备侧请求平台下发的设备影子数据。
     * 此监听器只能接收平台到直连设备的请求，子设备的请求由AbstractGateway处理
     * @param shadowListener 设备影子监听器
     */
    set shadowListener(value: ShadowListener | null);
    get shadowListener(): ShadowListener | null;
    private _rawDeviceMessageListener;
    /**
     * 设置消息监听器，用于接收平台下发的消息
     * 此监听器只能接收平台到直连设备的请求，子设备的请求由AbstractGateway处理
     *
     * @param rawDeviceMessageListener 消息监听器
     */
    set rawDeviceMessageListener(value: RawDeviceMessageListener | null);
    get rawDeviceMessageListener(): RawDeviceMessageListener | null;
    private _connectionListener;
    /**
     * 设置链路监听器，用户接收链路断开事件
     *
     * @param connectLostListener
     */
    set connectionListener(value: ConnectListener | null);
    get connectionListener(): ConnectListener | null;
    private _rawMessageListenerMap;
    set rawMessageListenerMap(value: Map<String, RawMessageListener>);
    get rawMessageListenerMap(): Map<String, RawMessageListener>;
    private _functionMap;
    /**
     * 设置各类topic处理的handler
     *
     * @param functionMap 各类topic处理的handler
     */
    set functionMap(value: Map<string, MessageReceivedHandler>);
    /**
     * 获取各类topic处理的handler
     *
     * @return 各类topic处理的handler
     */
    get functionMap(): Map<string, MessageReceivedHandler>;
    private _customOptions;
    set customOptions(value: CustomOptions);
    get customOptions(): CustomOptions;
    private _mqttClient;
    set mqttClient(value: MqttClient | null);
    get mqttClient(): MqttClient | null;
    private _clientConf;
    set clientConf(value: ClientConf);
    get clientConf(): ClientConf;
    private _device;
    set device(value: AbstractDevice);
    get device(): AbstractDevice;
    constructor(clientConf: ClientConf, device: AbstractDevice);
    connect(): Promise<boolean>;
    disconnect(): Promise<IoTMqttResponse>;
    destroy(): Promise<boolean>;
    isConnected(): Promise<boolean>;
    publish(publishOption: IoTMqttPublishOptions): Promise<IoTMqttResponse>;
    /**
     * 上报设备属性
     * @param properties 设备属性列表
     * @param qos        qos
     * @returns
     */
    reportProperties(properties: ServiceProperty[], qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 上报设备消息
     * @param deviceMessage 设备消息
     * @param qos           qos
     * @returns
     */
    reportDeviceMessage(deviceMessage: DeviceMessage, qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 上报事件
     * @param event
     * @param qos
     * @returns
     */
    reportEvent(event: DeviceEvent, qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 发布原始消息，原始消息和设备消息（DeviceMessage）的区别是：
     * 1、可以自定义topic，该topic需要在平台侧配置
     * 2、不限制payload的格式
     *
     * @param rawMessage 原始消息
     * @param qos
     */
    publishRawMessage(rawMessage: RawMessage, qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 上报命令响应
     *
     * @param requestId  请求id，响应的请求id必须和请求的一致
     * @param commandRsp 命令响应
     * @param qos
     */
    respondCommand(requestId: string, commandRsp: CommandRsp, qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 上报读属性响应
     *
     * @param requestId 请求id，响应的请求id必须和请求的一致
     * @param services  服务属性
     * @param qos
     */
    respondPropsGet(requestId: string, services: ServiceProperty[], qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 上报写属性响应
     *
     * @param requestId 请求id，响应的请求id必须和请求的一致
     * @param iotResult 写属性结果
     * @param qos
     */
    respondPropsSet(requestId: string, iotResult: IotResult, qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    /**
     * 获取设备影子
     *
     * @param shadowRequest 请求设备影子参数
     * @param listener      发布监听器
     */
    getShadow(shadowRequest: ShadowRequest, qos?: IoTMqttQos): Promise<import("@ohos/mqtt").MqttResponse>;
    /**
     * 订阅自定义topic。系统topic由SDK自动订阅，此接口只能用于订阅自定义topic
     *
     * @param topic              自定义topic
     * @param rawMessageListener 接收自定义消息的监听器
     * @param qos                qos
     */
    subscribeTopic(topic: string, rawMessageListener: RawMessageListener, qos?: IoTMqttQos): Promise<IoTMqttResponse>;
    private checkClientConf;
    /**
     * 接收消息处理
     */
    private messageArrived;
    private reportDeviceInfo;
    private subscribe;
    private connectComplete;
    private connectLost;
    private reconnect;
    private getWaitTImeUntilNextRetry;
    private sleep;
    private generateClientId;
    private generatePassword;
    private createMqtt;
}
