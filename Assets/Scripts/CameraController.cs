using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class CameraController : MonoBehaviour
{
    private float sens = 5f;
    private new Transform camera;
    
    private float moveSpeed = 8f;

    private float yRot;
    private float xRot;
    


    void Start()
    {
        camera = GetComponent<Transform>();
        Cursor.lockState = CursorLockMode.Locked;
        
        xRot = camera.localEulerAngles.x;
        yRot = camera.localEulerAngles.y;
    }


    void LateUpdate()
    {
        if (Input.GetMouseButton(1))

        {
            float mouseX = Input.GetAxisRaw("Mouse X")  * sens;
            float mouseY = Input.GetAxisRaw("Mouse Y")  * sens;

            yRot += mouseX;
            xRot -= mouseY;
        
            xRot = Mathf.Clamp(xRot, -90f, 90f);
            
            camera.transform.rotation = Quaternion.Euler(xRot, yRot, 0f);
        }
    }

    void Update()
    {
        Vector2 moveDir = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        
        Vector3 finalMove = transform.forward * moveDir.y + transform.right * moveDir.x;
        
        camera.transform.position += finalMove * (moveSpeed * Time.deltaTime);
          
    }
}
