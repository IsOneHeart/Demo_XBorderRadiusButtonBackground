# A solution for implementing an asymmetric rounded corner component based on Canvas in HarmonyOS

In modern UI design, there is often a need for unconventional rounded corner styles. This article provides an in-depth analysis of a dynamic Canvas-based rendering solution that can perfectly achieve hybrid effects combining inner and outer rounded corners through the combination of positive and negative radius values.

![](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/398/970/576/2850086000398970576.20250611162922.79664206680968662858940189365620:50001231000000:2800:7F59D8532751455C7385343CBA849F0195D7688325AA447A225B3D0875E96A5A.png)

### Core Implementation Principles

Conditional Logic:

When all four corners are either inner rounded corners or outer rounded corners, directly utilize ArkUI's standard borderRadius property:

```arkts
    if ((this.topRadius >= 0 && this.bottomRadius >= 0) || (this.topRadius < 0 && this.bottomRadius < 0)) {
      Column()
        .height('100%')
        .width('100%')
        .borderRadius(Math.abs(this.topRadius + this.bottomRadius) / 2)
        .backgroundColor(this.active ? this.activeColor : this.inactiveColor)
        .onClick(() => {
          this.action();
        })
    } 
```
Otherwise, use Canvas for drawing:

```arkts
else {
      Canvas(this.context).height('100%').width('100%')
        .onReady(() => {
          this.drawCanvas();
        })
    }
```

### Hybrid Rounded Corner Rendering Algorithm

Based on the combination of positive and negative parameters, enter one of two rendering modes:

### Mode One: Inner Rounded Corners at the Top + Outer Rounded Corners at the Bottom


```arkts
    if (this.topRadius >= 0 && this.bottomRadius < 0) {
      let p1: Point = { x: Math.abs(this.bottomRadius) + this.topRadius, y: this.topRadius }
      let p2: Point = { x: this.context.width - Math.abs(this.bottomRadius) - this.topRadius, y: this.topRadius }
      let p3: Point = { x: 0, y: this.context.height - Math.abs(this.bottomRadius) };
      let p4: Point = { x: this.context.width, y: this.context.height - Math.abs(this.bottomRadius) }
      this.context.moveTo(0, this.context.height);
      this.context.arc(p3.x, p3.y, Math.abs(this.bottomRadius), Math.PI / 2, 0, true);
      this.context.lineTo(p1.x - this.topRadius, p1.y);
      this.context.arc(p1.x, p1.y, this.topRadius, Math.PI, -Math.PI / 2);
      this.context.lineTo(p2.x, p2.y - this.topRadius);
      this.context.arc(p2.x, p2.y, this.topRadius, -Math.PI / 2, 0);
      this.context.lineTo(p4.x - Math.abs(this.bottomRadius), p4.y);
      this.context.arc(p4.x, p4.y, Math.abs(this.bottomRadius), Math.PI, Math.PI / 2, true);
      this.context.stroke();
      this.context.fill();
    }
```

### Mode Two: Outer Rounded Corners at the Top + Inner Rounded Corners at the Bottom

```arkts
else if (this.topRadius < 0 && this.bottomRadius >= 0) {
      let p1: Point = { x: 0, y: Math.abs(this.topRadius) }
      let p2: Point = { x: this.context.width, y: Math.abs(this.topRadius) }
      let p3: Point = { x: this.bottomRadius + Math.abs(this.topRadius), y: this.context.height - this.bottomRadius };
      let p4: Point = {
        x: this.context.width - this.bottomRadius - Math.abs(this.topRadius),
        y: this.context.height - this.bottomRadius
      }
      this.context.moveTo(0, 0);
      this.context.arc(p1.x, p1.y, Math.abs(this.topRadius), -Math.PI / 2, 0);
      this.context.lineTo(Math.abs(this.topRadius), this.context.height - this.bottomRadius);
      this.context.arc(p3.x, p3.y, this.bottomRadius, Math.PI, Math.PI / 2, true);
      this.context.lineTo(p4.x, this.context.height);
      this.context.arc(p4.x, p4.y, this.bottomRadius, Math.PI / 2, 0, true);
      this.context.lineTo(p2.x - Math.abs(this.topRadius), p2.y);
      this.context.arc(p2.x, p2.y, Math.abs(this.topRadius), Math.PI, -Math.PI / 2);
      this.context.lineTo(0, 0);
      this.context.stroke();
      this.context.fill();
    }
```

A complete example code of the encapsulated component:


```arkts
import { Point } from "@ohos.UiTest"

@ComponentV2
export struct XBorderRadiusButtonBackground {
  @Param topRadius: number = 20
  @Param bottomRadius: number = 20
  @Param activeColor: ResourceStr = '#ffffffff'
  @Param inactiveColor: ResourceStr = '#ff8a8a8a'
  @Param action: () => void = () => {
  }
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @Param active: boolean = true

  @Monitor('topRadius','bottomRadius','activeColor','inactiveColor','active')
  drawCanvas() {
    this.context.clearRect(0, 0, this.context.width, this.context.height);
    this.context.lineWidth = 0;
    this.context.fillStyle = (this.active ? this.activeColor : this.inactiveColor) as string;
    this.context.strokeStyle = (this.active ? this.activeColor : this.inactiveColor) as string;
    if (this.topRadius >= 0 && this.bottomRadius < 0) {
      //      _______
      //     /       \
      //     |        |
      // ___/          \___
      // Center Point 1
      let p1: Point = { x: Math.abs(this.bottomRadius) + this.topRadius, y: this.topRadius }
      // Center Point 2
      let p2: Point = { x: this.context.width - Math.abs(this.bottomRadius) - this.topRadius, y: this.topRadius }
      // Center Point 3
      let p3: Point = { x: 0, y: this.context.height - Math.abs(this.bottomRadius) };
      // Center Point 4
      let p4: Point = { x: this.context.width, y: this.context.height - Math.abs(this.bottomRadius) }
      this.context.moveTo(0, this.context.height);
      this.context.arc(p3.x, p3.y, Math.abs(this.bottomRadius), Math.PI / 2, 0, true);
      this.context.lineTo(p1.x - this.topRadius, p1.y);
      this.context.arc(p1.x, p1.y, this.topRadius, Math.PI, -Math.PI / 2);
      this.context.lineTo(p2.x, p2.y - this.topRadius);
      this.context.arc(p2.x, p2.y, this.topRadius, -Math.PI / 2, 0);
      this.context.lineTo(p4.x - Math.abs(this.bottomRadius), p4.y);
      this.context.arc(p4.x, p4.y, Math.abs(this.bottomRadius), Math.PI, Math.PI / 2, true);
      this.context.stroke();
      this.context.fill();
    } else if (this.topRadius < 0 && this.bottomRadius >= 0) {
      // Center Point 1
      let p1: Point = { x: 0, y: Math.abs(this.topRadius) }
      // Center Point 2
      let p2: Point = { x: this.context.width, y: Math.abs(this.topRadius) }
      // Center Point 3
      let p3: Point = { x: this.bottomRadius + Math.abs(this.topRadius), y: this.context.height - this.bottomRadius };
      // Center Point 4
      let p4: Point = {
        x: this.context.width - this.bottomRadius - Math.abs(this.topRadius),
        y: this.context.height - this.bottomRadius
      }
      this.context.moveTo(0, 0);
      this.context.arc(p1.x, p1.y, Math.abs(this.topRadius), -Math.PI / 2, 0);
      this.context.lineTo(Math.abs(this.topRadius), this.context.height - this.bottomRadius);
      this.context.arc(p3.x, p3.y, this.bottomRadius, Math.PI, Math.PI / 2, true);
      this.context.lineTo(p4.x, this.context.height);
      this.context.arc(p4.x, p4.y, this.bottomRadius, Math.PI / 2, 0, true);
      this.context.lineTo(p2.x - Math.abs(this.topRadius), p2.y);
      this.context.arc(p2.x, p2.y, Math.abs(this.topRadius), Math.PI, -Math.PI / 2);
      this.context.lineTo(0, 0);
      this.context.stroke();
      this.context.fill();
    }
  }

  build() {
    if ((this.topRadius >= 0 && this.bottomRadius >= 0) || (this.topRadius < 0 && this.bottomRadius < 0)) {
      Column()
        .height('100%')
        .width('100%')
        .borderRadius(Math.abs(this.topRadius + this.bottomRadius) / 2)
        .backgroundColor(this.active ? this.activeColor : this.inactiveColor)
        .onClick(() => {
          this.action();
        })
    } else {
      Canvas(this.context).height('100%').width('100%')
        .onReady(() => {
          this.drawCanvas();
        })
    }
  }
}
```
