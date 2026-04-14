# Package Search

Search for available packages across all supported distributions.

<div class="md-main__inner md-typeset">
  <div class="md-grid">
    <div class="md-content">
      <div class="package-filter-container" style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px;">
        <div style="flex: 1; min-width: 250px;">
          <input type="text" id="package-search" placeholder="Search by name..." class="md-input" style="width: 100%; height: 44px; padding: 0 16px; border: 1px solid var(--md-typeset-color--lightest); border-radius: 4px; background-color: var(--md-default-bg-color);">
        </div>
        <div style="width: 150px;">
          <select id="dist-filter" class="md-input" style="width: 100%; height: 44px; padding: 0 8px; border: 1px solid var(--md-typeset-color--lightest); border-radius: 4px; background-color: var(--md-default-bg-color); color: var(--md-typeset-color);">
            <option value="">All Distributions</option>
            <option value="debian">Debian/Ubuntu</option>
            <option value="redhat">RedHat/CentOS</option>
            <option value="alpine">Alpine Linux</option>
          </select>
        </div>
        <div style="width: 120px;">
          <select id="arch-filter" class="md-input" style="width: 100%; height: 44px; padding: 0 8px; border: 1px solid var(--md-typeset-color--lightest); border-radius: 4px; background-color: var(--md-default-bg-color); color: var(--md-typeset-color);">
            <option value="">All Arch</option>
            <option value="amd64">amd64/x86_64</option>
            <option value="arm64">arm64/aarch64</option>
            <option value="i386">i386</option>
          </select>
        </div>
      </div>
      
      <div id="package-results" class="md-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 16px; padding: 0;">
        <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
          <div class="md-status md-status--loading"></div>
          <p>Loading packages metadata...</p>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
    .package-card {
      border: 1px solid var(--md-typeset-color--lightest);
      padding: 16px;
      border-radius: 8px;
      background: var(--md-default-bg-color);
      transition: box-shadow 0.2s ease, border-color 0.2s ease;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    .package-card:hover {
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      border-color: var(--md-primary-fg-color);
    }
    .package-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 12px;
    }
    .package-name {
      font-weight: 700;
      color: var(--md-primary-fg-color);
      font-size: 1.1rem;
      word-break: break-all;
    }
    .package-dist-badge {
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 0.7rem;
      font-weight: bold;
      text-transform: uppercase;
      background: var(--md-primary-fg-color--transparent);
      color: var(--md-primary-fg-color);
    }
    .package-meta {
      font-size: 0.85rem;
      color: var(--md-typeset-color);
      margin: 4px 0;
    }
    .package-url {
      font-family: var(--md-code-font-family);
      font-size: 0.75rem;
      background: var(--md-code-bg-color);
      padding: 4px 8px;
      border-radius: 4px;
      word-break: break-all;
      margin-top: 8px;
      display: block;
      color: var(--md-primary-fg-color);
      text-decoration: none;
    }
    .package-url:hover {
      text-decoration: underline;
    }
    .no-results {
      grid-column: 1 / -1;
      text-align: center;
      padding: 40px;
      color: var(--md-typeset-color--light);
    }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    var searchInput = document.getElementById('package-search');
    var distFilter = document.getElementById('dist-filter');
    var archFilter = document.getElementById('arch-filter');
    var resultsDiv = document.getElementById('package-results');
    var BASE_PATH = '/pkg-linux/';

    if (searchInput && distFilter && archFilter) {
      // Use absolute path from site root
      fetch(BASE_PATH + 'data/packages.json')
        .then(response => {
           if (!response.ok) throw new Error('Failed to load packages.json');
           return response.json();
        })
        .then(packages => {
          window.allPackages = packages;
          
          function updateResults() {
            var query = searchInput.value.toLowerCase();
            var dist = distFilter.value.toLowerCase();
            var arch = archFilter.value.toLowerCase();
            
            var filtered = window.allPackages.filter(p => {
              var matchesSearch = p.name.toLowerCase().includes(query) || 
                                 (p.description && p.description.toLowerCase().includes(query));
              var matchesDist = dist === "" || p.dist.toLowerCase().includes(dist);
              var matchesArch = arch === "" || p.arch.toLowerCase().includes(arch);
              return matchesSearch && matchesDist && matchesArch;
            });
            renderPackages(filtered);
          }

          searchInput.addEventListener('input', updateResults);
          distFilter.addEventListener('change', updateResults);
          archFilter.addEventListener('change', updateResults);
          
          updateResults();
        })
        .catch(err => {
          resultsDiv.innerHTML = '<div class="no-results">Error: Could not load package data. Please ensure ' + BASE_PATH + 'data/packages.json is accessible.</div>';
          console.error(err);
        });
    }

    function renderPackages(packages) {
      if (!resultsDiv) return;
      
      if (packages.length === 0) {
        resultsDiv.innerHTML = '<div class="no-results">No packages found matching your criteria.</div>';
        return;
      }

      var html = packages.map(p => `
        <div class="package-card">
          <div class="package-header">
            <span class="package-name">${p.name}</span>
            <span class="package-dist-badge">${p.dist}</span>
          </div>
          <div>
            <div class="package-meta"><strong>Version:</strong> ${p.version}</div>
            <div class="package-meta"><strong>Architecture:</strong> ${p.arch}</div>
            <a href="${BASE_PATH}${p.url}" class="package-url" target="_blank">${p.url}</a>
          </div>
        </div>
      `).join('');
      resultsDiv.innerHTML = html;
    }
  });
</script>
