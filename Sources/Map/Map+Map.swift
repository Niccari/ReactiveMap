//
//  File.swift
//  
//
//  Created by Niccari on 12/06/2022.
//

import Foundation
import MapKit

extension Map {

    // MARK: Methods

    func processTapEvent(
        for mapView: MKMapView,
        of overlayContentByID: [OverlayItems.Element.ID: MapOverlay],
        on touchLocation: CGPoint
    ) {
        let locationCoordinate = mapView.convert(
            touchLocation, toCoordinateFrom: mapView.self)

        let tappedItems = mapView.overlays.filter {
            overlay in

            guard let renderer: MKOverlayPathRenderer = mapView.renderer(for: overlay) as? MKOverlayPathRenderer else { return false }
            let currentMapPoint: MKMapPoint = MKMapPoint(locationCoordinate)
            let viewPoint: CGPoint = renderer.point(for: currentMapPoint)

            var targetPath = renderer.path
            if overlay is MKPolyline || overlay is MKMultiPolyline {
                targetPath = targetPath?.copy(
                    strokingWithWidth: 5.0,    // FIXME: 本来は、polylineのstrokeWidthに応じた値にすべき
                    lineCap: .square,
                    lineJoin: .bevel,
                    miterLimit: .greatestFiniteMagnitude
                )
            }
            guard let targetPath = targetPath else { return false }
            return targetPath.contains(viewPoint)
        }

        if let tappedItem = tappedItems.first {
            if let id = overlayContentByID.first(where: { $0.value.overlay.hash == tappedItem.hash })?.key {
                if let item = self.overlayItems.first(where: { $0.id == id }) {
                    onOverlayTapped?(item)
                    return
                }
            }
        }
    }

}
