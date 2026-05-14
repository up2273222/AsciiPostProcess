using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEngine;

public class RotateThatRat : MonoBehaviour
{
    public float rotMult;

    private void FixedUpdate()
    {
        transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x,transform.rotation.eulerAngles.y + (1f * rotMult),transform.rotation.eulerAngles.z);
    }
}
