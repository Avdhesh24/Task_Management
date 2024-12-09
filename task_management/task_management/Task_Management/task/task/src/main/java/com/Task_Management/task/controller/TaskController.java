package com.Task_Management.task.controller;

import com.Task_Management.task.exception.ResourceNotFoundException;
import com.Task_Management.task.models.Task;
import com.Task_Management.task.service.TaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
@RequestMapping("/api/tasks")
@RequiredArgsConstructor
public class TaskController {
    private final TaskService taskService;

    // Create a new task
    @Operation(summary = "Create a new task", description = "Create a task and assign it to a user")
    @PostMapping
    public ResponseEntity<?> createTask(@RequestBody @Valid Task task) {
        String username = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (username == null || username.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(
                    Map.of("error", "Username is not available from the JWT token")
            );
        }

        Task createdTask = taskService.createTask(task, username);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdTask);
    }

    // Update an existing task
    @Operation(summary = "Update a task", description = "Update an existing task by id")
    @ApiResponse(responseCode = "200", description = "Task updated successfully")
    @PutMapping("/{id}")
    public ResponseEntity<?> updateTask(@PathVariable Long id, @RequestBody @Valid Task updatedTask) {
        Task task = taskService.updateTask(id, updatedTask);
        if (task == null) {
            throw new ResourceNotFoundException("Task with id " + id + " not found.");
        }
        return ResponseEntity.ok(task);
    }

    // Delete a task
    @Operation(summary = "Delete a task", description = "Delete an existing task by id")
    @ApiResponse(responseCode = "204", description = "Task deleted successfully")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTask(@PathVariable Long id) {
        String username = (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (!taskService.deleteTask(id, username)) {
            throw new ResourceNotFoundException("Task with id " + id + " not found.");
        }
        return ResponseEntity.noContent().build();
    }

    // Search tasks by keyword
    @Operation(summary = "Search tasks", description = "Search tasks by keyword")
    @ApiResponse(responseCode = "200", description = "List of tasks returned")
    @GetMapping("/search")
    public ResponseEntity<List<Task>> searchTasks(@RequestParam String keyword) {
        List<Task> tasks = taskService.searchTasks(keyword);
        return ResponseEntity.ok(tasks);
    }

    // Filter tasks by priority
    @Operation(summary = "Filter tasks by priority", description = "Get tasks filtered by priority")
    @ApiResponse(responseCode = "200", description = "Filtered list of tasks")
    @GetMapping("/filter")
    public ResponseEntity<List<Task>> filterTasks(@RequestParam String priority) {
        List<Task> tasks = taskService.filterTasksByPriority(priority);
        return ResponseEntity.ok(tasks);
    }
}
