# Package Search

Search for available packages across all supported distributions.

<div class="package-search-container">
  <input type="text" id="package-search" placeholder="Search for packages (e.g., git, curl)..." style="width: 100%; padding: 12px; font-size: 16px; border: 1px solid #ddd; border-radius: 8px;">
  <div id="package-results" style="margin-top: 20px;">Loading packages...</div>
</div>

<style>
    .package-card {
      border: 1px solid #eee;
      padding: 15px;
      margin-bottom: 10px;
      border-radius: 8px;
      background: #fafafa;
    }
    .package-name {
      font-weight: bold;
      color: #009688;
      font-size: 18px;
    }
    .package-dist {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 12px;
      margin-left: 10px;
      background: #e7f6f1;
      color: #009688;
    }
    .package-meta {
      font-size: 14px;
      color: #666;
      margin-top: 5px;
    }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    var searchInput = document.getElementById('package-search');
    if (searchInput) {
      // Use absolute path from site root
      fetch('/pkg-linux/site/packages.json')
        .then(response => response.json())
        .then(packages => {
          window.allPackages = packages;
          renderPackages(packages);
          
          searchInput.addEventListener('input', function() {
            var query = this.value.toLowerCase();
            var filtered = window.allPackages.filter(p => 
              p.name.toLowerCase().includes(query) || 
              p.dist.toLowerCase().includes(query)
            );
            renderPackages(filtered);
          });
        })
        .catch(err => {
          document.getElementById('package-results').innerHTML = 'No packages found or failed to load packages metadata.';
          console.error(err);
        });
    }

    function renderPackages(packages) {
      var resultsDiv = document.getElementById('package-results');
      if (!resultsDiv) return;
      
      if (packages.length === 0) {
        resultsDiv.innerHTML = '<p>No packages found.</p>';
        return;
      }

      var html = packages.map(p => `
        <div class="package-card">
          <div><span class="package-name">${p.name}</span> <span class="package-dist">${p.dist}</span></div>
          <div class="package-meta">Version: ${p.version} | Arch: ${p.arch}</div>
          <div class="package-meta">Path: <code>${p.url}</code></div>
        </div>
      `).join('');
      resultsDiv.innerHTML = html;
    }
  });
</script>
