using System;
using System.Linq;

public static class Store
{
    public static int QueueWithMinimalWaitingTime
    (
        int customersInQueue1, 
        int customersInQueue2, 
        int customersInQueue3
    )
    {
        int[] waitingTimes = {
            customersInQueue1 * 45,
            customersInQueue2 * 30,
            customersInQueue3 * 12
        };
        int minValIndex = Array.IndexOf(waitingTimes, waitingTimes.Min());
        return minValIndex + 1;
    }
}
