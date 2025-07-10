import { RawMessage } from "../../requests/RawMessage";
import { DeviceClient } from "../DeviceClient";
import { MessageReceivedHandler } from "./MessageReceivedHandler";
export declare class ShadowResponseHandler implements MessageReceivedHandler {
    private deviceClient;
    constructor(deviceClient: DeviceClient);
    messageHandler(message: RawMessage): void;
}
