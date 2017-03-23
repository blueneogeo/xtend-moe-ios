package xtend.moe.ios.annotations

import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.TransformationContext
import org.moe.natj.objc.ann.Selector

/**
 * Generates the NSObject alloc method for this class:
 * 
 * ```xtend
 * @Selector("init") override native MapViewController init()
 * ```
 */
@Active(InitProcessor)
annotation Init {
	
}

class InitProcessor extends AbstractClassProcessor {
	
	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		cls.addMethod('init') [
			native = true
			addAnnotation ( Selector.newAnnotationReference [ setStringValue('value', 'init') ] )
			returnType = cls.newTypeReference
		]
	}
	
}
