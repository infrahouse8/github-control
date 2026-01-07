# CODING_STANDARD.md Improvement Plan

**Purpose**: Enhance `modules/plain-repo/files/CODING_STANDARD.md` to be more comprehensive, better organized, and more actionable.

**Target File**: `modules/plain-repo/files/CODING_STANDARD.md`

**Impact**: All Terraform module repositories managed by github-control will receive the updated standard.

---

## Phase 1: Reorganization and Structure

### 1.1 Add Clear Section Headers
**Current State**: ~~Flat bullet list mixing languages and concerns~~ ✅ COMPLETED
**Goal**: Organize into logical sections with hierarchy

**Tasks**:
- [x] Create section structure:
  - [x] General Formatting (All Files) - added for universal standards
  - [x] Python Standards (General, Dependencies)
  - [x] Puppet Standards (placeholder for future)
  - [x] Terraform General Standards
  - [x] Terraform Validation Blocks (existing critical section)
  - [x] Terraform IAM Policies
  - [x] Terraform Tagging Standards
  - [x] Terraform Testing Standards
  - [ ] Terraform Variables (to be added in Phase 3)
  - [ ] Terraform Outputs (to be added in Phase 3)
  - [ ] Terraform Documentation (to be added in Phase 3)
- [x] Move existing bullets into appropriate sections
- [x] Ensure consistent formatting (heading levels, bullet styles)

**Completed**: Sections 1.1 reorganization is done. Some subsections like Variables, Outputs, and Documentation
will be added when content is available (Phase 3).

---

## Phase 2: Add Context and Rationale

### 2.1 Document "Why" for Each Guideline
**Current State**: ~~Rules without rationale~~ ✅ COMPLETED
**Goal**: Help developers understand and internalize the standards

**Tasks**:
- [x] Add rationale for tagging conventions
  - [x] Why lowercase except Name? (Case-sensitivity prevents confusion; AWS console convention for Name)
  - [x] Why is created_by_module required? (Resource provenance tracking - know what created each resource)
  - [x] Why require environment tags from users? (Prevents deployment mistakes, no sensible default)
- [x] Add rationale for version pinning strategies
  - [x] Why exact versions for modules? (One change at a time; Renovate manages updates)
  - [x] Why ~= for Python deps? (Trust semver; libraries need ranges; auto security fixes)
- [x] Add rationale for provider requirements rule (Separation of concerns)
- [x] Add rationale for IAM data source policy preference (Data sources handle versioning correctly)

**Format**: Brief 1-sentence explanation in sub-bullets

**Completed**: All existing guidelines now have clear rationale explaining the "why" behind each rule.

---

## Phase 3: Expand Terraform Coverage

### 3.1 Add Terraform Naming Conventions
**Current State**: ~~Not documented~~ ✅ COMPLETED
**Goal**: Consistent naming across all modules

**Tasks**:
- [x] Define variable naming patterns:
  - [x] Boolean variables: `enable_*`/`create_*` for verbs, `is_*` for nouns
  - [x] Plural vs singular for lists (use plural)
  - [x] Underscore conventions (snake_case everywhere)
- [x] Define resource naming patterns (`this`/`main` for single, descriptive names for multiple)
- [x] Define locals naming patterns (descriptive snake_case)
- [x] Define output naming patterns (group with prefixes)
- [x] Provide examples for each

### 3.2 Add Variable Standards
**Current State**: ~~Only HEREDOC for descriptions mentioned~~ ✅ COMPLETED
**Goal**: Complete variable guidelines

**Tasks**:
- [x] Guidelines for default values (when required vs optional)
- [x] Validation best practices:
  - [x] When to add validation (catch definitely wrong values)
  - [x] How to write actionable error messages (explain what's wrong, include fix instructions)
  - [x] Common validation patterns (format checks, ranges, no arbitrary constraints)
- [x] Type constraints best practices (always specify explicit types)
- [x] Sensitive variable handling (mark sensitive, use infrahouse/secret/aws module)

### 3.3 Add Output Standards
**Current State**: ~~Not documented~~ ✅ COMPLETED
**Goal**: Consistent, useful outputs

**Tasks**:
- [x] When to create outputs (reasonable judgment, under-do vs over-do)
- [x] How to group related outputs (covered in naming conventions)
- [x] When outputs need descriptions (always)
- [x] Sensitive output handling (mark as sensitive = true)

### 3.4 Add Documentation Standards
**Current State**: ~~Not documented~~ ✅ COMPLETED
**Goal**: Clear guidelines for code documentation

**Tasks**:
- [x] When inline comments are needed (explain "why" not "what")
- [x] Module-level documentation requirements (README.md with badges, description, examples)
- [x] Examples directory requirements (desired but optional)
- [x] README.md requirements (terraform-docs markers, badges, usage examples)
- [x] Integration with terraform-docs (.terraform-docs.yml managed by github-control)

### 3.5 Add Resource Organization Patterns
**Current State**: ~~Not documented~~ ✅ COMPLETED
**Goal**: Consistent code organization

**Tasks**:
- [x] When to use `count` vs `for_each` (count for simple enable/disable, for_each for collections)
- [x] When to extract logic to `locals` (readability, DRY principle)
- [x] How to organize files in a module (main.tf, variables.tf, outputs.tf minimum; split by function)
- [x] Dependencies and ordering best practices (prefer implicit, use depends_on as bugfix)

**Completed**: Phase 3 is fully complete with all Terraform coverage areas documented.

### 3.6 Expand Security Standards
**Current State**: ~~Only IAM policy format mentioned~~ ✅ COMPLETED
**Goal**: Comprehensive security guidelines

**Tasks**:
- [x] Secrets handling (use infrahouse/secret/aws module, never hardcode)
- [x] Least privilege principles (general requirement, ISO/SOC compliance)
- [x] Security group best practices (avoid 0.0.0.0/0, prefer SG refs, ICMP rules)
- [x] Encryption requirements (at rest: enable by default, CMK for CloudTrail; in transit: HTTPS/TLS with policy
  hierarchy)
- [x] Logging and auditing standards (365 day retention, CloudTrail, VPC Flow Logs, CloudWatch, AWS Config)

**Completed**: Comprehensive security section added with ISO27001/SOC2 compliance requirements.

---

## Phase 4: Add Examples and Clarity

### 4.1 Add Missing Examples
**Current State**: ~~Some guidelines lack concrete examples~~ ✅ COMPLETED
**Goal**: Every guideline has a clear example

**Tasks**:
- [x] Add HEREDOC example for variable descriptions (lines 36-45)
- [x] Add module pinning example with source and version (lines 55-69)
- [x] Add IAM data source vs JSON example (lines 231-263)
- [x] Add tagging example showing all required tags (lines 282-297)
- [x] Add terraform.tfvars example for testing (lines 301-310)

**Completed**: All key examples added with clear CORRECT/WRONG comparisons where applicable.

### 4.2 Expand Existing Examples
**Current State**: ~~Minimal examples~~ ✅ COMPLETED
**Goal**: Complete, realistic examples

**Tasks**:
- [x] Expand validation block example to show multiple scenarios (Puppet env name, CIDR, range, list, nullable)
- [x] Add more complex validation patterns (regex, format checks, range validation)
- [x] Show complete variable blocks with all elements (required, optional, complex, sensitive, wrong examples)

**Completed**: Comprehensive examples added showing real-world validation patterns and complete variable structures.

---

## Phase 5: Expand Testing Section

### 5.1 Add Testing Standards
**Current State**: ~~Only mentions where tests run~~ ✅ COMPLETED
**Goal**: Complete testing guidelines

**Tasks**:
- [x] Testing philosophy (integration tests, create real infrastructure)
- [x] Testing framework (pytest, pytest-infrahouse, infrahouse-core)
- [x] What should be tested (happy path, edge cases, resource creation, outputs)
- [x] Test coverage requirements (two AWS provider versions)
- [x] Makefile requirements (test-keep, test-clean with configurable parameters)
- [x] Development workflow (local dev, before PR, CI/CD, merge)
- [x] CI/CD requirements (terraform.tfvars, self-hosted runner, 12-hour role session)

**Completed**: Comprehensive testing standards added covering entire development and CI/CD workflow.

---

## Phase 6: Python Standards Enhancement

### 6.1 Expand Python Section
**Current State**: ~~Only docstrings and dependencies~~ ✅ COMPLETED
**Goal**: More complete Python standards

**Tasks**:
- [x] Code formatting (Black for formatting and CI checks)
- [x] Linting standards (pylint with .pylintrc)
- [x] Type hinting requirements (required for all functions)
- [x] Testing standards (pytest with meaningful tests, happy/unhappy paths, no coverage requirements)
- [x] Error handling patterns (never use "except Exception", let it crash)
- [x] Logging standards (use setup_logging() from infrahouse_core.logging)

**Completed**: Comprehensive Python standards added with formatting, linting, type hints, testing philosophy, error
handling best practices, and logging configuration.

---

## Phase 7: Makefile Standards

### 7.1 Clarify Makefile Guidelines
**Current State**: ~~"Use Makefile-example" is vague~~ ✅ COMPLETED
**Goal**: Clear, specific Makefile patterns

**Tasks**:
- [x] Document required targets (help default, bootstrap, install-hooks, test, test-keep, test-clean, clean, format,
  lint, release-*)
- [x] Document target naming conventions (lowercase with hyphens)
- [x] Document PHONY targets usage (declare all non-file-producing targets)
- [x] Show examples of common patterns (bootstrap, install-hooks, clean, format, lint, release-patch)
- [x] Document best practices (variables with ?=, target dependencies, tabs not spaces)

**Completed**: Comprehensive Makefile Standards section added (lines 597-722) with all required targets, naming
conventions, PHONY usage, examples, and best practices. Covers both Python and Terraform module requirements.

---

## Implementation Order Recommendation

**Priority 1 (High Impact, Low Effort)**:
1. Phase 1: Reorganization - makes everything easier to use
2. Phase 4.1: Add missing examples - clarifies existing guidelines
3. Phase 3.2: Variable standards - frequently used

**Priority 2 (High Impact, Medium Effort)**:
1. Phase 3.1: Naming conventions - reduces inconsistency
2. Phase 3.3: Output standards - improves module usability
3. Phase 5: Testing standards - prevents bugs

**Priority 3 (Medium Impact)**:
1. Phase 2: Add rationale - helps with adoption
2. Phase 3.4: Documentation standards
3. Phase 3.5: Resource organization

**Priority 4 (Nice to Have)**:
1. Phase 6: Python expansion (if needed)
2. Phase 7: Makefile clarification
3. Phase 3.6: Extended security standards

---

## Success Criteria

- [x] Document is well-organized with clear sections (General Formatting, Python, Terraform with subsections, Puppet,
  Makefile)
- [x] Every guideline has a rationale (at least brief) (Phase 2 added rationale throughout)
- [x] Every guideline has an example (Phase 4 added comprehensive examples with CORRECT/WRONG patterns)
- [x] Covers all major Terraform patterns used in InfraHouse modules (Phase 3: naming, variables, outputs,
  documentation, organization, security, validation, IAM, tagging, testing)
- [x] New developers can follow it without asking clarifying questions (comprehensive examples and rationale for all
  guidelines)
- [x] Claude Code can unambiguously apply all guidelines (clear rules with concrete examples and anti-patterns)
- [x] Document prevents recurring bugs (like the nullable validation issue) (ternary operator rule prominently featured
  in Validation Blocks section)

---

## Notes

- Keep the document concise - prefer clear examples over lengthy prose
- Use consistent formatting throughout
- Consider splitting into multiple files if it gets too long (CODING_STANDARD.md, SECURITY.md, TESTING.md)
- Update `instructions.md` if new critical items are added
- Test changes by having Claude Code review real module code against the new standards
