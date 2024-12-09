package com.Task_Management.task.service;

import com.Task_Management.task.models.Task;

import java.util.List;

public interface TaskService {
    Task createTask(Task task, String username);

    Task updateTask(Long id, Task updatedTask);

    boolean deleteTask(Long id, String username);

    List<Task> searchTasks(String keyword);

    List<Task> filterTasksByPriority(String priority);
}
