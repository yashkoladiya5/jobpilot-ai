/**
 * Custom error class for API-related exceptions.
 * Extends the built-in Error class to include HTTP status codes.
 */
export class ApiError extends Error {
  public readonly statusCode: number;
  public readonly isOperational: boolean;

  constructor(statusCode: number, message: string, isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    Object.setPrototypeOf(this, ApiError.prototype);
  }

  static badRequest(message: string): ApiError {
    return new ApiError(400, message);
  }

  static unauthorized(message: string): ApiError {
    return new ApiError(401, message);
  }

  static notFound(message: string): ApiError {
    return new ApiError(404, message);
  }

  static forbidden(message: string): ApiError {
    return new ApiError(403, message);
  }

  static unprocessableEntity(message: string): ApiError {
    return new ApiError(422, message);
  }

  static tooManyRequests(message: string): ApiError {
    return new ApiError(429, message);
  }

  static internal(message: string): ApiError {
    return new ApiError(500, message);
  }

  static notImplemented(message: string = "Not Implemented"): ApiError {
    return new ApiError(501, message);
  }

  static badGateway(message: string = "Bad Gateway"): ApiError {
    return new ApiError(502, message);
  }
  
  static serviceUnavailable(message: string = "Service Unavailable"): ApiError {
    return new ApiError(503, message);
  }
}
