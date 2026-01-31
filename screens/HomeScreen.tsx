import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    ScrollView,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useUser, useClerk } from '@clerk/clerk-expo';
import { LogOut, MapPin, Camera, Bell } from 'lucide-react-native';

const HomeScreen = () => {
    const { user } = useUser();
    const { signOut } = useClerk();

    const handleSignOut = async () => {
        try {
            await signOut();
        } catch (error) {
            console.error('Sign out error:', error);
        }
    };

    return (
        <SafeAreaView style={styles.container}>
            <ScrollView contentContainerStyle={styles.scrollContent}>
                {/* Header */}
                <View style={styles.header}>
                    <View style={styles.headerLeft}>
                        <Text style={styles.greeting}>Welcome back,</Text>
                        <Text style={styles.userName}>
                            {user?.firstName || user?.emailAddresses[0]?.emailAddress?.split('@')[0] || 'User'}
                        </Text>
                    </View>
                    <TouchableOpacity onPress={handleSignOut} style={styles.signOutButton}>
                        <LogOut size={24} stroke="#FFF" />
                    </TouchableOpacity>
                </View>

                {/* User Card */}
                <View style={styles.userCard}>
                    <View style={styles.avatarContainer}>
                        {user?.imageUrl ? (
                            <Image source={{ uri: user.imageUrl }} style={styles.avatar} />
                        ) : (
                            <View style={styles.avatarPlaceholder}>
                                <Text style={styles.avatarText}>
                                    {user?.firstName?.[0] || user?.emailAddresses[0]?.emailAddress?.[0]?.toUpperCase() || 'U'}
                                </Text>
                            </View>
                        )}
                    </View>
                    <View style={styles.userInfo}>
                        <Text style={styles.userFullName}>
                            {user?.fullName || 'CitySense User'}
                        </Text>
                        <Text style={styles.userEmail}>
                            {user?.emailAddresses[0]?.emailAddress}
                        </Text>
                    </View>
                </View>

                {/* Quick Actions */}
                <Text style={styles.sectionTitle}>Quick Actions</Text>
                <View style={styles.actionsGrid}>
                    <TouchableOpacity style={styles.actionCard}>
                        <View style={[styles.actionIcon, { backgroundColor: '#E8F5E9' }]}>
                            <Camera size={28} stroke="#4CAF50" />
                        </View>
                        <Text style={styles.actionText}>Report Issue</Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.actionCard}>
                        <View style={[styles.actionIcon, { backgroundColor: '#E3F2FD' }]}>
                            <MapPin size={28} stroke="#2196F3" />
                        </View>
                        <Text style={styles.actionText}>View Map</Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.actionCard}>
                        <View style={[styles.actionIcon, { backgroundColor: '#FFF3E0' }]}>
                            <Bell size={28} stroke="#FF9800" />
                        </View>
                        <Text style={styles.actionText}>Notifications</Text>
                    </TouchableOpacity>
                </View>

                {/* Stats */}
                <Text style={styles.sectionTitle}>Your Impact</Text>
                <View style={styles.statsCard}>
                    <View style={styles.statItem}>
                        <Text style={styles.statNumber}>0</Text>
                        <Text style={styles.statLabel}>Reports</Text>
                    </View>
                    <View style={styles.statDivider} />
                    <View style={styles.statItem}>
                        <Text style={styles.statNumber}>0</Text>
                        <Text style={styles.statLabel}>Resolved</Text>
                    </View>
                    <View style={styles.statDivider} />
                    <View style={styles.statItem}>
                        <Text style={styles.statNumber}>0</Text>
                        <Text style={styles.statLabel}>Points</Text>
                    </View>
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
        paddingHorizontal: 20,
        paddingBottom: 30,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingVertical: 20,
    },
    headerLeft: {
        flex: 1,
    },
    greeting: {
        fontSize: 16,
        color: '#AAA',
    },
    userName: {
        fontSize: 28,
        fontWeight: '700',
        color: '#FFF',
        marginTop: 4,
    },
    signOutButton: {
        width: 48,
        height: 48,
        borderRadius: 24,
        backgroundColor: 'rgba(255,255,255,0.1)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    userCard: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#2A2A2A',
        borderRadius: 20,
        padding: 20,
        marginBottom: 30,
    },
    avatarContainer: {
        marginRight: 16,
    },
    avatar: {
        width: 70,
        height: 70,
        borderRadius: 35,
    },
    avatarPlaceholder: {
        width: 70,
        height: 70,
        borderRadius: 35,
        backgroundColor: '#4CAF50',
        justifyContent: 'center',
        alignItems: 'center',
    },
    avatarText: {
        fontSize: 28,
        fontWeight: '700',
        color: '#FFF',
    },
    userInfo: {
        flex: 1,
    },
    userFullName: {
        fontSize: 20,
        fontWeight: '600',
        color: '#FFF',
        marginBottom: 4,
    },
    userEmail: {
        fontSize: 14,
        color: '#AAA',
    },
    sectionTitle: {
        fontSize: 20,
        fontWeight: '700',
        color: '#FFF',
        marginBottom: 16,
    },
    actionsGrid: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginBottom: 30,
    },
    actionCard: {
        flex: 1,
        backgroundColor: '#2A2A2A',
        borderRadius: 16,
        padding: 16,
        alignItems: 'center',
        marginHorizontal: 5,
    },
    actionIcon: {
        width: 56,
        height: 56,
        borderRadius: 28,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 12,
    },
    actionText: {
        fontSize: 12,
        fontWeight: '600',
        color: '#FFF',
        textAlign: 'center',
    },
    statsCard: {
        flexDirection: 'row',
        backgroundColor: '#2A2A2A',
        borderRadius: 20,
        padding: 24,
        justifyContent: 'space-around',
    },
    statItem: {
        alignItems: 'center',
    },
    statNumber: {
        fontSize: 32,
        fontWeight: '700',
        color: '#4CAF50',
        marginBottom: 4,
    },
    statLabel: {
        fontSize: 14,
        color: '#AAA',
    },
    statDivider: {
        width: 1,
        backgroundColor: '#444',
    },
});

export default HomeScreen;
