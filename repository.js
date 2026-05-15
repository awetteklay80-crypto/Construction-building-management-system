// ========== REPOSITORY PATTERN ==========
// Separates data access logic from business logic
// Benefits: Cleaner code, easier database changes, better testability

class ProjectRepository {
    constructor(db) {
        this.db = db; // In-memory database (can be swapped with PostgreSQL)
    }

    // Get all projects
    async findAll() {
        return this.db.projects;
    }

    // Find project by ID
    async findById(id) {
        return this.db.projects.find(p => p.id === parseInt(id));
    }

    // Create new project
    async create(projectData) {
        const newProject = {
            id: this.db.projects.length + 1,
            ...projectData,
            status: 'Planning',
            progress: 0,
            spent: 0,
            startDate: new Date().toISOString().slice(0, 10)
        };
        this.db.projects.push(newProject);
        return newProject;
    }

    // Update project progress
    async updateProgress(id, progress) {
        const index = this.db.projects.findIndex(p => p.id === parseInt(id));
        if (index !== -1) {
            this.db.projects[index].progress = parseInt(progress);
            this.db.projects[index].updatedAt = new Date().toISOString();
            return this.db.projects[index];
        }
        return null;
    }

    // Delete project
    async delete(id) {
        const index = this.db.projects.findIndex(p => p.id === parseInt(id));
        if (index !== -1) {
            this.db.projects.splice(index, 1);
            return true;
        }
        return false;
    }
}

class TaskRepository {
    constructor(db) {
        this.db = db;
    }

    async findAll() {
        return this.db.tasks;
    }

    async findByProject(projectId) {
        return this.db.tasks.filter(t => t.projectId === parseInt(projectId));
    }

    async create(taskData) {
        const newTask = {
            id: this.db.tasks.length + 1,
            ...taskData,
            projectId: parseInt(taskData.projectId),
            status: 'pending',
            createdAt: new Date().toISOString().slice(0, 10)
        };
        this.db.tasks.push(newTask);
        return newTask;
    }

    async updateStatus(id, status) {
        const index = this.db.tasks.findIndex(t => t.id === parseInt(id));
        if (index !== -1) {
            this.db.tasks[index].status = status;
            this.db.tasks[index].updatedAt = new Date().toISOString();
            return this.db.tasks[index];
        }
        return null;
    }
}

class ResourceRepository {
    constructor(db) {
        this.db = db;
    }

    async findAll() {
        return this.db.resources;
    }

    async create(resourceData) {
        const newResource = {
            id: this.db.resources.length + 1,
            ...resourceData,
            projectId: parseInt(resourceData.projectId),
            used: 0,
            createdAt: new Date().toISOString().slice(0, 10)
        };
        this.db.resources.push(newResource);
        return newResource;
    }

    async updateUsage(id, used) {
        const index = this.db.resources.findIndex(r => r.id === parseInt(id));
        if (index !== -1) {
            this.db.resources[index].used = parseInt(used);
            return this.db.resources[index];
        }
        return null;
    }
}

module.exports = { ProjectRepository, TaskRepository, ResourceRepository };
