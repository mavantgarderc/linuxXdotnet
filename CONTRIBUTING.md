# 00 – Contributing Guidelines

## Submit Contributions

```bash
git clone https://github.com/mavantgarderc/linuxXdotnet.git
cd linuxXdotnet
git checkout -b feature/add-new-cheatsheet
# Add your .md file to appropriate folder (docs/, linux/, cli/, cheats/)
git add .
git commit -m "docs/09: Add Blazor Server cheats"
git push origin feature/add-new-cheatsheet
```

## Guidelines

- **One command per code block** (bash only)
- **3 lines maximum** per explanation
- **LTS-focused** (.NET 6/8); note 7/9 differences
- **No Windows content**
- **Formal tone**, troubleshooting-first
- Test commands on **Arch** or **Ubuntu** before submitting

**See ISSUE_TEMPLATE.md** for bug reports.
