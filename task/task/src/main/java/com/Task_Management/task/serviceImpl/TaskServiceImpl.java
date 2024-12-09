package com.Task_Management.task.serviceImpl;

import com.Task_Management.task.models.Task;
import com.Task_Management.task.models.User;
import com.Task_Management.task.repository.TaskRepository;
import com.Task_Management.task.service.TaskService;
import com.Task_Management.task.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;
    private final UserService userService;

    @Override
    public Task createTask(Task task, String username) {
        User creator = userService.getUserByUsername(username);
        task.setCreatedBy(creator);
        return taskRepository.save(task);
    }

    @Override
    public Task updateTask(Long id, Task updatedTask) {
        Task existingTask = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Task not found"));
        existingTask.setTitle(updatedTask.getTitle());
        existingTask.setDescription(updatedTask.getDescription());
        existingTask.setDueDate(updatedTask.getDueDate());
        existingTask.setAssignedUser(updatedTask.getAssignedUser());
        return taskRepository.save(existingTask);
    }

    @Override
    public boolean deleteTask(Long id, String username) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Task not found"));
        User user = userService.getUserByUsername(username);
        if (!task.getCreatedBy().equals(user) && !task.getAssignedUser().equals(user)) {
            throw new RuntimeException("Permission denied");
        }
        taskRepository.deleteById(id);
        return false;
    }

    @Override
    public List<Task> searchTasks(String keyword) {
        return taskRepository.searchTasks(keyword);
    }

    @Override
    public List<Task> filterTasksByPriority(String priority) {
        return taskRepository.findByPriority(priority);
    }
}
