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
    } else if (this.topRadius < 0 && this.bottomRadius >= 0) {
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
      Canvas(this.context).height('100%').width('100%')//.backgroundColor(Color.Red)
        .onReady(() => {
          this.drawCanvas();
        })
    }
  }
}