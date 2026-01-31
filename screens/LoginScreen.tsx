import React, { useCallback, useState } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TextInput,
    TouchableOpacity,
    Image,
    ScrollView,
    ActivityIndicator,
} from 'react-native';
import { User, Lock, Eye, EyeOff, CheckSquare, Square } from 'lucide-react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useOAuth, useSignIn } from '@clerk/clerk-expo';
import * as WebBrowser from 'expo-web-browser';
import * as Linking from 'expo-linking';

// Warm up the browser for Android OAuth
WebBrowser.maybeCompleteAuthSession();

const LoginScreen = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const [rememberMe, setRememberMe] = useState(false);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState('');

    // Google OAuth
    const { startOAuthFlow } = useOAuth({ strategy: 'oauth_google' });

    const handleGoogleSignIn = useCallback(async () => {
        try {
            setIsLoading(true);
            setError('');

            const { createdSessionId, setActive } = await startOAuthFlow({
                redirectUrl: Linking.createURL('/oauth-callback', { scheme: 'citysense' }),
            });

            if (createdSessionId && setActive) {
                await setActive({ session: createdSessionId });
            }
        } catch (err: any) {
            console.error('OAuth error:', err);
            setError(err?.errors?.[0]?.message || 'Failed to sign in with Google');
        } finally {
            setIsLoading(false);
        }
    }, [startOAuthFlow]);

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollContent} bounces={false}>
                {/* Header Section */}
                <View style={styles.header}>
                    <View style={styles.logoContainer}>
                        <Image
                            source={require('../assets/logo.png')}
                            style={styles.logo}
                            resizeMode="contain"
                        />
                    </View>
                    <Text style={styles.appName}>CitySense</Text>
                    <Text style={styles.tagline}>Keep Your City Clean & Beautiful</Text>
                </View>

                {/* Login Card */}
                <View style={styles.card}>
                    <Text style={styles.welcomeText}>Welcome Back</Text>
                    <Text style={styles.subtitle}>Sign in to your account</Text>

                    {/* Error Message */}
                    {error ? (
                        <View style={styles.errorContainer}>
                            <Text style={styles.errorText}>{error}</Text>
                        </View>
                    ) : null}

                    {/* Google Sign In Button */}
                    <TouchableOpacity
                        style={styles.googleButton}
                        onPress={handleGoogleSignIn}
                        disabled={isLoading}
                    >
                        {isLoading ? (
                            <ActivityIndicator color="#1A1A1A" size="small" />
                        ) : (
                            <>
                                <Image
                                    source={{ uri: 'https://www.google.com/favicon.ico' }}
                                    style={styles.googleIcon}
                                />
                                <Text style={styles.googleButtonText}>Sign in with Google</Text>
                            </>
                        )}
                    </TouchableOpacity>

                    {/* Divider */}
                    <View style={styles.divider}>
                        <View style={styles.dividerLine} />
                        <Text style={styles.dividerText}>or continue with email</Text>
                        <View style={styles.dividerLine} />
                    </View>

                    {/* Username Input */}
                    <View style={styles.inputContainer}>
                        <User size={20} color="#666" style={styles.inputIcon} />
                        <TextInput
                            style={styles.input}
                            placeholder="Username"
                            placeholderTextColor="#999"
                            value={username}
                            onChangeText={setUsername}
                            autoCapitalize="none"
                        />
                    </View>

                    {/* Password Input */}
                    <View style={styles.inputContainer}>
                        <Lock size={20} color="#666" style={styles.inputIcon} />
                        <TextInput
                            style={styles.input}
                            placeholder="Password"
                            placeholderTextColor="#999"
                            secureTextEntry={!showPassword}
                            value={password}
                            onChangeText={setPassword}
                        />
                        <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
                            {showPassword ? (
                                <EyeOff size={20} color="#666" />
                            ) : (
                                <Eye size={20} color="#666" />
                            )}
                        </TouchableOpacity>
                    </View>

                    {/* Remember Me & Forgot Password */}
                    <View style={styles.row}>
                        <TouchableOpacity
                            style={styles.checkboxContainer}
                            onPress={() => setRememberMe(!rememberMe)}
                        >
                            {rememberMe ? (
                                <CheckSquare size={18} color="#1A1A1A" />
                            ) : (
                                <Square size={18} color="#666" />
                            )}
                            <Text style={styles.checkboxLabel}>Remember me</Text>
                        </TouchableOpacity>
                        <TouchableOpacity>
                            <Text style={styles.forgotPassword}>Forgot Password?</Text>
                        </TouchableOpacity>
                    </View>

                    {/* Login Button */}
                    <TouchableOpacity style={styles.loginButton} disabled={isLoading}>
                        <Text style={styles.loginButtonText}>LOGIN</Text>
                    </TouchableOpacity>
                </View>

                {/* Footer */}
                <View style={styles.footer}>
                    <Text style={styles.footerText}>
                        Don't have an account? <Text style={styles.registerLink}>Register</Text>
                    </Text>
                </View>
            </ScrollView>
        </SafeAreaView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#1A1A1A',
    },
    scrollContent: {
        flexGrow: 1,
    },
    header: {
        alignItems: 'center',
        paddingVertical: 40,
    },
    logoContainer: {
        width: 120,
        height: 120,
        borderRadius: 60,
        backgroundColor: '#FFF',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 20,
        overflow: 'hidden',
    },
    logo: {
        width: 100,
        height: 100,
    },
    appName: {
        fontSize: 32,
        fontWeight: '700',
        color: '#FFF',
        marginBottom: 8,
    },
    tagline: {
        fontSize: 16,
        color: '#CCC',
    },
    card: {
        flex: 1,
        backgroundColor: '#FFF',
        borderTopLeftRadius: 40,
        borderTopRightRadius: 40,
        paddingHorizontal: 30,
        paddingTop: 40,
        paddingBottom: 20,
    },
    welcomeText: {
        fontSize: 28,
        fontWeight: '700',
        color: '#000',
        marginBottom: 4,
    },
    subtitle: {
        fontSize: 16,
        color: '#666',
        marginBottom: 24,
    },
    errorContainer: {
        backgroundColor: '#FFEBEE',
        borderRadius: 10,
        padding: 12,
        marginBottom: 16,
    },
    errorText: {
        color: '#C62828',
        fontSize: 14,
        textAlign: 'center',
    },
    googleButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#FFF',
        borderWidth: 1.5,
        borderColor: '#E0E0E0',
        borderRadius: 15,
        height: 55,
        marginBottom: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.05,
        shadowRadius: 4,
        elevation: 2,
    },
    googleIcon: {
        width: 24,
        height: 24,
        marginRight: 12,
    },
    googleButtonText: {
        fontSize: 16,
        fontWeight: '600',
        color: '#333',
    },
    divider: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 20,
    },
    dividerLine: {
        flex: 1,
        height: 1,
        backgroundColor: '#E0E0E0',
    },
    dividerText: {
        marginHorizontal: 12,
        fontSize: 13,
        color: '#999',
    },
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#F5F5F5',
        borderRadius: 15,
        paddingHorizontal: 15,
        marginBottom: 20,
        height: 55,
    },
    inputIcon: {
        marginRight: 12,
    },
    input: {
        flex: 1,
        fontSize: 16,
        color: '#000',
    },
    row: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 30,
    },
    checkboxContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    checkboxLabel: {
        fontSize: 14,
        color: '#666',
        marginLeft: 8,
    },
    forgotPassword: {
        fontSize: 14,
        fontWeight: '700',
        color: '#000',
    },
    loginButton: {
        backgroundColor: '#1A1A1A',
        borderRadius: 15,
        height: 55,
        justifyContent: 'center',
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
        elevation: 3,
        marginTop: 10,
    },
    loginButtonText: {
        color: '#FFF',
        fontSize: 16,
        fontWeight: '700',
        letterSpacing: 1,
    },
    footer: {
        backgroundColor: '#FFF',
        paddingBottom: 40,
        alignItems: 'center',
    },
    footerText: {
        fontSize: 14,
        color: '#999',
    },
    registerLink: {
        color: '#000',
        fontWeight: '700',
    },
});

export default LoginScreen;
