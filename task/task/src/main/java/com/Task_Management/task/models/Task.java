package com.Task_Management.task.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    private String title;

    private String description;

    @FutureOrPresent
    private LocalDate dueDate;

    private boolean completed = false;

    @ManyToOne
    private User assignedUser;

    @ManyToOne
    private User createdBy;

    private String priority; // HIGH, MEDIUM, LOW

    @PrePersist
    private void setDefaults() {
        if (priority == null) {
            priority = "MEDIUM";
        }
    }
}
