import json
import os
import urllib.request
import numpy as np

def load_mnist():
    # просто файлообменник типо
    url = "https://storage.googleapis.com/tensorflow/tf-keras-datasets/mnist.npz"
    path = "mnist.npz"

    if not os.path.exists(path):
        urllib.request.urlretrieve(url, path)
    with np.load(path, allow_pickle=True) as f:
        x_train, y_train = f['x_train'], f['y_train']
        x_test, y_test = f['x_test'], f['y_test']


    x_train = x_train.reshape(-1, 784).astype("float32") / 255.0
    x_test = x_test.reshape(-1, 784).astype("float32") / 255.0

    return x_train, y_train, x_test, y_test


def relu(x):
    return np.maximum(0, x)

def relu_derivative(x):
    return (x > 0).astype(float)

def softmax(x):
    exp_x = np.exp(x - np.max(x, axis=1, keepdims=True))
    return exp_x / np.sum(exp_x, axis=1, keepdims=True)

def one_hot(y, classes=10):
    one_hot_y = np.zeros((y.size, classes))
    one_hot_y[np.arange(y.size), y] = 1
    return one_hot_y

def main():
    x_train, y_train, x_test, y_test = load_mnist()
    y_train_oh = one_hot(y_train)
    y_test_oh = one_hot(y_test)

    W1 = np.random.randn(784, 128) * np.sqrt(2.0 / 784)
    b1 = np.zeros(128)
    
    W2 = np.random.randn(128, 10) * np.sqrt(2.0 / 128)
    b2 = np.zeros(10)

    epochs = 1500
    batch_size = 128
    learning_rate = 0.1
    m = x_train.shape[0]
    
    for epoch in range(epochs):
        permutation = np.random.permutation(m)
        x_train_shuffled = x_train[permutation]
        y_train_shuffled = y_train_oh[permutation]
        
        for i in range(0, m, batch_size):
            X_batch = x_train_shuffled[i:i+batch_size]
            Y_batch = y_train_shuffled[i:i+batch_size]
            batch_m = X_batch.shape[0]

            Z1 = np.dot(X_batch, W1) + b1
            A1 = relu(Z1)
            
            Z2 = np.dot(A1, W2) + b2
            A2 = softmax(Z2)

            dZ2 = A2 - Y_batch
            
            dW2 = np.dot(A1.T, dZ2) / batch_m
            db2 = np.sum(dZ2, axis=0) / batch_m
            
            dA1 = np.dot(dZ2, W2.T)
            dZ1 = dA1 * relu_derivative(Z1)
            
            dW1 = np.dot(X_batch.T, dZ1) / batch_m
            db1 = np.sum(dZ1, axis=0) / batch_m

            W1 -= learning_rate * dW1
            b1 -= learning_rate * db1
            W2 -= learning_rate * dW2
            b2 -= learning_rate * db2

        Z1_test = np.dot(x_test, W1) + b1
        A1_test = relu(Z1_test)
        Z2_test = np.dot(A1_test, W2) + b2
        A2_test = softmax(Z2_test)
        
        predictions = np.argmax(A2_test, axis=1)
        accuracy = np.mean(predictions == y_test)
        print(f"Эпоха {epoch + 1}/{epochs} - Точность на тесте: {accuracy * 100:.2f}%")

    print("\nЭкспорт весов...")
    weights_dict = {
        "fc1": {
            "weights": W1.T.tolist(),
            "biases":  b1.tolist(),
        },
        "fc2": {
            "weights": W2.T.tolist(),
            "biases":  b2.tolist(),
        },
    }

    os.makedirs("assets", exist_ok=True)
    out_path = os.path.join("assets", "mnist_weights.json")
    with open(out_path, "w") as f:
        json.dump(weights_dict, f, separators=(",", ":"))

    size_mb = os.path.getsize(out_path) / 1024 / 1024
    print(f"Сохранено: {out_path} ({size_mb:.2f} МБ)")
    print("=" * 60)

if __name__ == "__main__":
    main()