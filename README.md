# ETB
<div style="text-align: center;"> <h3></h3> <p><strong>Database Management Project</strong></p>
<p><strong>Group: 18</strong></p>


<p text-align: center><strong>Submitted to: Prof. Ashok Harnal</strong></p>


<p text-align: center><strong>Submitted By:</strong></p>

<ul>
    <li>Disha Mishra - 341136</li>
    <li>Drishti Badoni - 341140</li>
    <li>Elizabeth Alphonsa Dominic - 341142</li>
</ul>
</div>

# Automobile Supply Chain Management (Ford)

A comprehensive database design for managing an end-to-end **Automobile Supply Chain**, from sourcing raw materials to customer delivery. This project models procurement, production, inventory, logistics, and sales operations using relational ER diagrams and structured entity relationships.

---
<img width="1224" height="634" alt="image" src="https://github.com/user-attachments/assets/cb6a102b-8d75-472c-a9f1-d86dfa70c3fb" />


## Project Overview

This system ensures seamless coordination between:
- **Component Suppliers**
- **Manufacturing Plants**
- **Inventory Management**
- **Production Scheduling & Tracking**
- **Sales & Customer Orders**
- **Inbound & Outbound Logistics**

It provides accurate tracking of component parts, vehicle configurations, shipments, costs, and customer order fulfillment.

---

## Core Entities & Relationships

| Module | Key Entities |
|--------|--------------|
| Procurement | `Component_Parts`, `Suppliers`, `PurchaseOrder_Master` |
| Inbound Logistics | `InboundShipment`, `Carriers` |
| Manufacturing | `Plants`, `BillOfMaterials`, `ProductionSchedule`, `ProductionStatusRecord` |
| Inventory | `InventoryTransaction` |
| Vehicle Config | `Vehicle_Model_Config` |
| Outbound Logistics | `OutboundShipment`, `Carriers` |
| Sales | `SalesOrders`, `Customer` |

---

## Supply Chain Flow

```mermaid
flowchart TD
    A[Component Parts] --> B[Suppliers]
    B --> C[Purchase Order]
    C --> D[Inbound Shipment]
    D --> E[Receiving Plant]
    E --> F[Inventory Transaction]
    F --> G[Production Schedule]
    G --> H[Production Status]
    H --> I[Sales Order]
    I --> J[Outbound Shipment]
    J --> K[Customer Delivery]
