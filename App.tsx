import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View, ActivityIndicator, Text } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { ClerkProvider, ClerkLoaded, useAuth } from '@clerk/clerk-expo';
import { tokenCache, publishableKey } from './lib/clerk';
import LoginScreen from './screens/LoginScreen';
import HomeScreen from './screens/HomeScreen';

// Main navigation component that switches between Login and Home
function RootNavigator() {
    const { isLoaded, isSignedIn } = useAuth();

    // Show loading while Clerk is initializing
    if (!isLoaded) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#4CAF50" />
                <Text style={styles.loadingText}>Loading...</Text>
            </View>
        );
    }

    // Show HomeScreen if signed in, otherwise show LoginScreen
    return isSignedIn ? <HomeScreen /> : <LoginScreen />;
}

export default function App() {
    return (
        <ClerkProvider tokenCache={tokenCache} publishableKey={publishableKey}>
            <ClerkLoaded>
                <SafeAreaProvider>
                    <View style={styles.container}>
                        <RootNavigator />
                        <StatusBar style="light" />
                    </View>
                </SafeAreaProvider>
            </ClerkLoaded>
        </ClerkProvider>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#1A1A1A',
    },
    loadingContainer: {
        flex: 1,
        backgroundColor: '#1A1A1A',
        justifyContent: 'center',
        alignItems: 'center',
    },
    loadingText: {
        color: '#FFF',
        marginTop: 16,
        fontSize: 16,
    },
});
