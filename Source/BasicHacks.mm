uintptr_t baseAddr = getUnityBase();
if (!baseAddr) return;

ImGuiIO& io = ImGui::GetIO();
ImDrawList* drawList = ImGui::GetBackgroundDrawList();

// اللوب (محتاجين نتأكد إن الليست دي شغالة في اللعبة دي)
// ملاحظة: الدالة GetEntityAtIndex دي بتعتمد على طريقة اللعبة في تخزين اللاعبين
/*
for (int i = 0; i < entityCount; i++) {
    void* currentEntity = GetEntityAtIndex(entityList, i); 
    if (!currentEntity) continue;
    
    void* entityMovement = *(void**)((uintptr_t)currentEntity + ENTITY_MOVEMENT_OFFSET); 
    if (!entityMovement) continue;

    Vector3 playerPos = *(Vector3*)((uintptr_t)entityMovement + ENTITY_POSITION_OFFSET); 
    
    ImVec2 screenPos;
    if (WorldToScreen(playerPos, screenPos, io.DisplaySize.x, io.DisplaySize.y, cameraInstance, baseAddr)) {
        
        float boxWidth = 50.0f;
        float boxHeight = 100.0f;
        
        drawList->AddRect(
            ImVec2(screenPos.x - (boxWidth / 2), screenPos.y - boxHeight), 
            ImVec2(screenPos.x + (boxWidth / 2), screenPos.y), 
            IM_COL32(255, 0, 0, 255), 0.0f, 0, 2.0f
        );
        
        drawList->AddLine(
            ImVec2(io.DisplaySize.x / 2, io.DisplaySize.y), 
            ImVec2(screenPos.x, screenPos.y), 
            IM_COL32(255, 255, 255, 255), 1.5f
        );
    }
}
*/
