package fr.thibma.lamap.activities

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.LatLng
import fr.thibma.lamap.R

class MainActivity : AppCompatActivity(), OnMapReadyCallback {

    private lateinit var toolbar: Toolbar
    private lateinit var googleMap: GoogleMap

    private val permissionRequest = registerForActivityResult(ActivityResultContracts.RequestPermission()) {
        if (it) {
            permissionGranted()
        }
        else {
            // Demander les permissions
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        toolbar = findViewById(R.id.toolbar)
        setSupportActionBar(toolbar)

        val mapFragment = SupportMapFragment.newInstance()
        supportFragmentManager
            .beginTransaction()
            .add(R.id.map, mapFragment)
            .commit()
        mapFragment.getMapAsync(this)
    }

    override fun onMapReady(map: GoogleMap) {
        this.googleMap = map
        val permission = Manifest.permission.ACCESS_FINE_LOCATION
        when (PackageManager.PERMISSION_GRANTED) {
            ContextCompat.checkSelfPermission(this, permission) -> permissionGranted()
            else -> permissionRequest.launch(permission)
        }
    }

    @SuppressLint("MissingPermission")
    private fun permissionGranted() {
        googleMap.isMyLocationEnabled = true
        LocationServices.getFusedLocationProviderClient(this).lastLocation.addOnCompleteListener { location ->
            googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(location.result.latitude, location.result.longitude), 15F))
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.toolbar, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when(item.itemId) {
            R.id.action_friends -> {
                // Menu amis
                true
            }
        }
        return super.onOptionsItemSelected(item)
    }
}