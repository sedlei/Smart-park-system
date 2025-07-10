import { RawMessage } from "../../requests/RawMessage";
import { DeviceClient } from "../DeviceClient";
import { MessageReceivedHandler } from "./MessageReceivedHandler";
export declare class CommandHandler implements MessageReceivedHandler {
    private deviceClient;
    constructor(deviceClient: DeviceClient);
    messageHandler(message: RawMessage): void;
}
