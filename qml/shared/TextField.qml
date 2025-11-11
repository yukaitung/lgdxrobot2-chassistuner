import QtQuick.Controls
import QtQuick.Layouts

TextField {
  id: control
  width: 150
  height: 36
  Layout.preferredWidth: 150
  Layout.preferredHeight: 36
  onFocusChanged: if (focus) control.selectAll()
}