<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
        <%@taglib uri="jakarta.tags.core" prefix="c" %>
            <%@taglib uri="jakarta.tags.functions" prefix="fn" %>
                <t:layout title="Goods Receipt Note">
                    <!-- SweetAlert2 -->
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                    <div class="container-fluid py-4">
                        <!-- Back Link -->
                        <div class="mb-3">
                            <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                                class="text-decoration-none text-muted">
                                <i class="fas fa-arrow-left me-1"></i> Back to List
                            </a>
                        </div>

                        <form action="${pageContext.request.contextPath}/goods-receipt" method="post" id="grnForm">
                            <input type="hidden" name="action" value="save" />
                            <input type="hidden" name="grnId" value="${grnId}" />
                            <input type="hidden" name="grnNumber" id="grnNumberHidden"
                                value="${oldGrnNumber != null ? oldGrnNumber : ''}" />

                            <div class="row">
                                <!-- Header Section -->
                                <div class="col-lg-12">
                                    <div class="card shadow-sm border-0 mb-4">
                                        <div class="card-header bg-primary text-white py-3">
                                            <h5 class="card-title mb-0"><i class="fas fa-file-invoice me-2"></i>
                                                Header Information</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row g-3">
                                                <div class="col-md-4">
                                                    <label class="form-label fw-bold">Purchase Order</label>
                                                    <div class="position-relative" id="poCombobox">
                                                        <c:set var="initialPoNumber" value="" />
                                                        <c:if test="${not empty oldPoId}">
                                                            <c:forEach var="po" items="${purchaseOrders}">
                                                                <c:if test="${po.poId == oldPoId}">
                                                                    <c:set var="initialPoNumber"
                                                                        value="${po.poNumber}" />
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:if>
                                                        <div class="input-group">
                                                            <span class="input-group-text bg-light"><i
                                                                    class="fas fa-shopping-cart"></i></span>
                                                            <input type="text" id="poSearchInput"
                                                                class="form-control ${not empty fieldErrors.poId ? 'is-invalid' : ''}"
                                                                placeholder="-- Choose or Search PO --"
                                                                autocomplete="off" value="${initialPoNumber}">
                                                            <button
                                                                class="btn btn-outline-secondary dropdown-toggle dropdown-toggle-split"
                                                                type="button" id="poToggleBtn"></button>
                                                        </div>
                                                        <input type="hidden" name="poId" id="poIdHidden"
                                                            value="${oldPoId != null ? oldPoId : ''}" required>
                                                        <div id="poDropdownList"
                                                            class="dropdown-menu w-100 shadow-sm overflow-auto"
                                                            style="max-height: 400px; display: none; z-index: 1050;">
                                                            <c:forEach var="po" items="${purchaseOrders}">
                                                                <button type="button" class="dropdown-item py-2"
                                                                    data-id="${po.poId}" data-number="${po.poNumber}">
                                                                    <span class="fw-bold">${po.poNumber}</span> <span
                                                                        class="text-muted small ml-1">(#${po.poId})</span>
                                                                </button>
                                                            </c:forEach>
                                                            <div id="noPoMessage"
                                                                class="dropdown-item disabled text-muted text-center py-2"
                                                                style="display: none;">No matching orders</div>
                                                        </div>
                                                    </div>
                                                    <c:if test="${not empty fieldErrors.poId}">
                                                        <div class="text-danger small mt-1">${fieldErrors.poId}</div>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label fw-bold">GRN Number</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-light"><i
                                                                class="fas fa-hashtag"></i></span>
                                                        <input type="text" class="form-control bg-light"
                                                            id="grnNumberDisplay"
                                                            value="${oldGrnNumber != null ? oldGrnNumber : ''}"
                                                            readonly>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label fw-bold">Supplier</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-light"><i
                                                                class="fas fa-truck"></i></span>
                                                        <select class="form-control" name="supplierId"
                                                            id="supplierSelect" disabled>
                                                            <option value="">-- Auto-filled from PO --</option>
                                                            <c:forEach var="s" items="${suppliers}">
                                                                <option value="${s.supplierId}"
                                                                    ${oldSupplierId==s.supplierId ? 'selected' : '' }>
                                                                    ${s.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-12">
                                                    <label class="form-label fw-bold">Internal Note</label>
                                                    <textarea class="form-control" name="note" rows="2"
                                                        placeholder="Any special instructions or observations...">${oldNote != null ? oldNote : ''}</textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Lines Section -->
                                <div class="col-lg-12">
                                    <div class="card shadow-sm border-0">
                                        <div
                                            class="card-header d-flex justify-content-between align-items-center bg-dark text-white py-3">
                                            <h5 class="card-title mb-0"><i class="fas fa-boxes me-2"></i>SKU Details
                                            </h5>
                                            <c:if test="${not empty fieldErrors.lines}">
                                                <span class="badge bg-danger">${fieldErrors.lines}</span>
                                            </c:if>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle mb-0" id="linesTable">
                                                    <thead
                                                        class="table-light text-center text-secondary text-uppercase small">
                                                        <tr>
                                                            <th style="min-width: 250px;">Product</th>
                                                            <th style="width: 120px;">Price</th>
                                                            <th style="width: 120px;">Quantity</th>
                                                            <th style="width: 100px;">Good</th>
                                                            <th style="width: 100px;">Damaged</th>
                                                            <th style="width: 100px;">Missing</th>
                                                            <th>Note</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light py-3 d-flex justify-content-end gap-2">
                                            <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                                                class="btn btn-outline-secondary px-4">Cancel</a>
                                            <button class="btn btn-primary px-5 shadow-sm" type="submit"
                                                style="background-color: #4e73df; border-color: #4e73df;">
                                                <i class="fas fa-cart-arrow-down me-2"></i>Go to Putaway
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </t:layout>

                <style>
                    .input-group-text {
                        border-right: none;
                    }

                    .form-control:focus+.input-group-text {
                        border-color: #86b7fe;
                    }

                    .table th {
                        font-weight: 600;
                    }

                    .card {
                        border-radius: 0.5rem;
                        overflow: hidden;
                    }

                    .error-message {
                        color: #dc3545;
                        font-size: 0.75rem;
                        margin-top: 0.25rem;
                        display: none;
                    }

                    .is-invalid-field {
                        border-color: #dc3545 !important;
                    }

                    #poDropdownList {
                        top: 100%;
                        left: 0;
                        margin-top: 2px;
                    }

                    #poDropdownList .dropdown-item {
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    #poDropdownList .dropdown-item:hover {
                        background-color: #f8f9fa;
                        padding-left: 1.5rem;
                    }

                    /* Quantity Input colors */
                    .bg-good {
                        background-color: #e8f5e9 !important;
                        /* Light green */
                        border-color: #c8e6c9 !important;
                    }

                    .bg-damaged {
                        background-color: #ffebee !important;
                        /* Light red */
                        border-color: #ffcdd2 !important;
                    }

                    .bg-missing {
                        background-color: #fffde7 !important;
                        /* Light yellow */
                        border-color: #fff9c4 !important;
                    }

                    .bg-good:focus {
                        background-color: #f1f8f1 !important;
                        box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.1) !important;
                    }

                    .bg-damaged:focus {
                        background-color: #fff5f5 !important;
                        box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.1) !important;
                    }

                    .bg-missing:focus {
                        background-color: #fffeee !important;
                        box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.1) !important;
                    }
                </style>

                <%-- Variants data: dùng data-attributes thay vì JSON để tránh quote-escaping --%>
                    <div id="variantsData" style="display:none">
                        <c:forEach var="v" items="${variants}">
                            <span data-id="${v.variantId}" data-sku="<c:out value='${v.variantSku}'/>"
                                data-name="<c:out value='${v.productName}'/>"></span>
                        </c:forEach>
                    </div>

                    <script id="oldLinesData" type="application/json">
                ${not empty oldLinesJson ? oldLinesJson : '[]'}
            </script>

                    <script>
                        let idx = 0;
                        // Đọc variants từ data attributes (an toàn với mọi ký tự đặc biệt)
                        const variants = Array.from(
                            document.querySelectorAll('#variantsData span')
                        ).map(el => ({
                            id: el.dataset.id,
                            sku: el.dataset.sku,
                            name: el.dataset.name
                        }));

                        function addLine(data = null) {
                            const tbody = document.querySelector("#linesTable tbody");
                            const tr = document.createElement("tr");
                            tr.className = "line-row";

                            let productName = "Unknown Product";
                            if (data && data.variantId) {
                                const v = variants.find(v => v.id == data.variantId);
                                if (v) productName = v.sku + " - " + v.name;
                            }

                            tr.innerHTML = `
<td style="min-width: 250px;">
    <input type="hidden" name="lines[\${idx}].poLineId" value="\${data ? data.poLineId : ''}">
    <input type="hidden" name="lines[\${idx}].variantId" value="\${data ? data.variantId : ''}">
    <span class="small fw-semibold">\${productName}</span>
</td>
<td style="width: 120px;">
    <input type="number" class="form-control form-control-sm text-center bg-light" value="\${data ? Number(data.unitPrice).toFixed(2) : '0.00'}" readonly>
</td>
<td style="width: 120px;">
    <input type="number" class="form-control form-control-sm text-center bg-light qty-expected" name="lines[\${idx}].qtyExpected" value="\${data ? Math.floor(data.qtyExpected) : 0}" readonly>
</td>
<td style="width: 100px;">
    <input type="number" min="0" step="1" class="form-control form-control-sm text-center bg-good qty-good" 
           name="lines[\${idx}].qtyGood" value="\${data && data.fromOld ? Math.floor(data.qtyGood) : 0}" 
           oninput="this.value = Math.abs(Math.floor(this.value))"
           onfocus="if(this.value=='0') this.value='';" onblur="if(this.value=='') this.value='0';">
</td>
<td style="width: 100px;">
    <input type="number" min="0" step="1" class="form-control form-control-sm text-center bg-damaged qty-damaged" 
           name="lines[\${idx}].qtyDamaged" value="\${data && data.fromOld ? Math.floor(data.qtyDamaged) : 0}" 
           oninput="this.value = Math.abs(Math.floor(this.value))"
           onfocus="if(this.value=='0') this.value='';" onblur="if(this.value=='') this.value='0';">
</td>
<td style="width: 100px;">
    <input type="number" min="0" step="1" class="form-control form-control-sm text-center bg-missing qty-missing" 
           name="lines[\${idx}].qtyMissing" value="\${data && data.fromOld ? Math.floor(data.qtyMissing) : 0}" 
           oninput="this.value = Math.abs(Math.floor(this.value))"
           onfocus="if(this.value=='0') this.value='';" onblur="if(this.value=='') this.value='0';">
</td>
<td>
    <input type="text" class="form-control form-control-sm" name="lines[\${idx}].note" placeholder="Remark" value="\${data ? data.note : ''}">
</td>
`;
                            tbody.appendChild(tr);

                            const trError = document.createElement("tr");
                            trError.innerHTML = `
<td colspan="7" class="border-0 py-0 ps-3">
    <div class="error-message mb-2" id="error_\${idx}"></div>
</td>
`;
                            tbody.appendChild(trError);
                            idx++;
                        }

                        // Initialize with lines
                        document.addEventListener("DOMContentLoaded", function () {
                            const oldLinesData = document.getElementById('oldLinesData').textContent;
                            const oldLines = JSON.parse(oldLinesData);

                            if (oldLines && oldLines.length > 0) {
                                oldLines.forEach(line => {
                                    line.fromOld = true;
                                    addLine(line);
                                });
                            }

                            // --- Integrated PO Combobox Logic ---
                            const poCombobox = document.getElementById('poCombobox');
                            const poSearchInput = document.getElementById('poSearchInput');
                            const poToggleBtn = document.getElementById('poToggleBtn');
                            const poDropdownList = document.getElementById('poDropdownList');
                            const poIdHidden = document.getElementById('poIdHidden');
                            const noPoMessage = document.getElementById('noPoMessage');
                            const dropdownItems = poDropdownList.querySelectorAll('.dropdown-item:not(#noPoMessage)');

                            function showDropdown() {
                                poDropdownList.style.display = 'block';
                            }

                            function hideDropdown() {
                                poDropdownList.style.display = 'none';
                            }

                            function filterPO() {
                                const term = poSearchInput.value.toLowerCase().trim();
                                let count = 0;
                                dropdownItems.forEach(item => {
                                    const text = item.getAttribute('data-number').toLowerCase();
                                    if (text.includes(term)) {
                                        item.style.display = 'block';
                                        count++;
                                    } else {
                                        item.style.display = 'none';
                                    }
                                });
                                noPoMessage.style.display = count === 0 ? 'block' : 'none';
                            }

                            poSearchInput.addEventListener('focus', showDropdown);
                            poSearchInput.addEventListener('click', showDropdown);
                            poSearchInput.addEventListener('input', () => {
                                showDropdown();
                                filterPO();
                                if (poSearchInput.value.trim() === "") {
                                    poIdHidden.value = "";
                                    fetchPoDetails("");
                                }
                            });

                            poToggleBtn.addEventListener('click', (e) => {
                                e.stopPropagation();
                                if (poDropdownList.style.display === 'none') {
                                    showDropdown();
                                    poSearchInput.focus();
                                } else {
                                    hideDropdown();
                                }
                            });

                            // Handle selection
                            dropdownItems.forEach(item => {
                                item.addEventListener('click', function () {
                                    const poId = this.getAttribute('data-id');
                                    const poNumber = this.getAttribute('data-number');

                                    poSearchInput.value = poNumber;
                                    poIdHidden.value = poId;
                                    hideDropdown();

                                    // Trigger data fetch
                                    fetchPoDetails(poId);
                                });
                            });

                            // Close on click outside
                            document.addEventListener('click', (e) => {
                                if (!poCombobox.contains(e.target)) {
                                    hideDropdown();
                                }
                            });

                            async function fetchPoDetails(poId) {
                                if (!poId) {
                                    document.querySelector("#linesTable tbody").innerHTML = '';
                                    document.getElementById('supplierSelect').value = '';
                                    document.getElementById('grnNumberHidden').value = '';
                                    document.getElementById('grnNumberDisplay').value = '';
                                    return;
                                }

                                try {
                                    const resp = await fetch(`${pageContext.request.contextPath}/goods-receipt?action=getPoDetails&poId=\${poId}`);
                                    if (!resp.ok) throw new Error("Failed to fetch PO details");
                                    const data = await resp.json();

                                    // Update Supplier
                                    if (data.supplierId) {
                                        document.getElementById('supplierSelect').disabled = false;
                                        document.getElementById('supplierSelect').value = data.supplierId;
                                        document.getElementById('supplierSelect').disabled = true;
                                    }

                                    if (data.grnNumber) {
                                        document.getElementById('grnNumberHidden').value = data.grnNumber;
                                        document.getElementById('grnNumberDisplay').value = data.grnNumber;
                                    }

                                    // Clear and Populate Lines
                                    const tbody = document.querySelector("#linesTable tbody");
                                    tbody.innerHTML = '';
                                    idx = 0;

                                    data.lines.forEach(l => {
                                        addLine({
                                            poLineId: l.poLineId,
                                            variantId: l.variantId,
                                            unitPrice: l.unitPrice,
                                            qtyExpected: l.orderedQty,
                                            qtyGood: 0,
                                            qtyDamaged: 0,
                                            qtyMissing: 0,
                                            note: '',
                                            fromOld: false
                                        });
                                    });
                                } catch (err) {
                                    console.error(err);
                                    alert("Có lỗi khi tải thông tin PO: " + err.message);
                                }
                            }

                            // Form validation
                            document.getElementById('grnForm').addEventListener('submit', function (e) {
                                e.preventDefault();
                                const form = this;
                                const rows = document.querySelectorAll('.line-row');

                                let hasError = false;

                                if (rows.length === 0) {
                                    Swal.fire({
                                        icon: 'warning',
                                        title: 'No Items',
                                        text: 'Please select a Purchase Order to display items.'
                                    });
                                    return;
                                }

                                rows.forEach((row, index) => {
                                    const qExp = parseFloat(row.querySelector(`.qty-expected`).value) || 0;
                                    const qGoodField = row.querySelector(`.qty-good`);
                                    const qDamagedField = row.querySelector(`.qty-damaged`);
                                    const qMissingField = row.querySelector(`.qty-missing`);
                                    const errorDiv = document.getElementById(`error_\${index}`);

                                    // Clear previous errors
                                    errorDiv.style.display = 'none';
                                    errorDiv.textContent = '';
                                    [qGoodField, qDamagedField, qMissingField].forEach(f => f.classList.remove('is-invalid-field'));

                                    const qGood = parseFloat(qGoodField.value) || 0;
                                    const qDamaged = parseFloat(qDamagedField.value) || 0;
                                    const qMissing = parseFloat(qMissingField.value) || 0;

                                    const totalReceived = qGood + qDamaged + qMissing;

                                    if (qGood === 0 && qDamaged === 0 && qMissing === 0) {
                                        errorDiv.textContent = 'At least one quantity must be greater than 0';
                                        errorDiv.style.display = 'block';
                                        [qGoodField, qDamagedField, qMissingField].forEach(f => f.classList.add('is-invalid-field'));
                                        hasError = true;
                                    } else if (qGood + qDamaged > qExp) {
                                        errorDiv.textContent = `Good and Damaged quantities exceeds ordered quantity (\${qExp})`;
                                        errorDiv.style.display = 'block';
                                        [qGoodField, qDamagedField].forEach(f => f.classList.add('is-invalid-field'));
                                        hasError = true;
                                    } else if (qMissing > qExp) {
                                        errorDiv.textContent = `Missing quantity cannot exceed ordered quantity (\${qExp})`;
                                        errorDiv.style.display = 'block';
                                        qMissingField.classList.add('is-invalid-field');
                                        hasError = true;
                                    } else if (totalReceived > qExp) {
                                        errorDiv.textContent = `Total quantity (including Missing) exceeds ordered quantity (\${qExp})`;
                                        errorDiv.style.display = 'block';
                                        [qGoodField, qDamagedField, qMissingField].forEach(f => f.classList.add('is-invalid-field'));
                                        hasError = true;
                                    } else if (totalReceived < qExp) {
                                        errorDiv.textContent = `Quantity incomplete. Please record missing amount to match (\${qExp})`;
                                        errorDiv.style.display = 'block';
                                        [qGoodField, qDamagedField, qMissingField].forEach(f => f.classList.add('is-invalid-field'));
                                        hasError = true;
                                    }
                                });

                                if (hasError) {
                                    return;
                                }

                                // Perfect match
                                document.getElementById('supplierSelect').disabled = false;
                                form.submit();
                            });
                        });
                    </script>